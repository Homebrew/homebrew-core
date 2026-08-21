class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v16.0.0.tar.gz"
  sha256 "537e2948843eeebfba80cec6f2018ca2bee96c61783ac4f2408fa9602f732f08"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "210c3d7e4e404b25effba54100cfde4606d2f841383d310331da04bd20bba571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "210c3d7e4e404b25effba54100cfde4606d2f841383d310331da04bd20bba571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "210c3d7e4e404b25effba54100cfde4606d2f841383d310331da04bd20bba571"
    sha256 cellar: :any_skip_relocation, sonoma:        "68426e35f81b7a4d89cdf293169d04e258a2f412691092830ed07e803c8ce4f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdda9823eadcb7216f399261d5c2c9e1a719f6439a9a783a041d4c65d5bb2a93"
    sha256 cellar: :any,                 x86_64_linux:  "308bcb904c6b76beec03ee846f9f5972250731a1f91203aeee4dc14193731adf"
  end

  depends_on "go" => :build

  def install
    mv ".fastly/config.toml", "pkg/config/config.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -X github.com/fastly/cli/pkg/revision.AppVersion=v#{version}
      -X github.com/fastly/cli/pkg/revision.GitCommit=#{tap.user}
      -X github.com/fastly/cli/pkg/revision.GoHostOS=#{os}
      -X github.com/fastly/cli/pkg/revision.GoHostArch=#{arch}
      -X github.com/fastly/cli/pkg/revision.Environment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/fastly"

    generate_completions_from_executable(bin/"fastly", shell_parameter_format: "--completion-script-",
                                                       shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastly version")

    ENV["FASTLY_API_TOKEN"] = "invalid-token"
    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "401 Unauthorized", output
  end
end
