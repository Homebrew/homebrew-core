class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v15.1.0.tar.gz"
  sha256 "e14342f24d8e37c27a1ac7347fdf3a85607e4a44dbfbbf39d452b36033db7f46"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e849096453f488c72e5060f4678a8c439a17b5dac83babaa5f42410465fc5314"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e849096453f488c72e5060f4678a8c439a17b5dac83babaa5f42410465fc5314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e849096453f488c72e5060f4678a8c439a17b5dac83babaa5f42410465fc5314"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c3325f22e80a1bceafd25d5a4eb821815bb9a38a4bf506e6ca980e61b2d2192"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "725ed5a2aa909dab33ec1c85d329eda866ec96c33cee03d72490d6e7e5a7961e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b7dc0ba9d8049afa80fbd089e39cd924b9845dbe0bfa79f93ccfb36923ead6a"
  end

  depends_on "go" => :build

  def install
    mv ".fastly/config.toml", "pkg/config/config.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -s -w
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
