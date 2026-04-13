class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v14.3.0.tar.gz"
  sha256 "e146f6b7bba8aac4d4d7409fe590ba6d581a238c3e5f1239cb3c67451dfac683"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edb9aed05d0c2ba210fc5dc0f8c5859d68787edb09ee2eca510ba5097a02eab3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edb9aed05d0c2ba210fc5dc0f8c5859d68787edb09ee2eca510ba5097a02eab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edb9aed05d0c2ba210fc5dc0f8c5859d68787edb09ee2eca510ba5097a02eab3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb56afb449f9856091e1faf6879c745e896eb4a42f344f43c257205243976108"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94c3f31e881e5112fe3daef86514cac1cfe67f40d66f3fd8e267440ea2355476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9cafbd0c04b1a6a13d7bcfd290ddc92cc6b81851f3c1332e87e76ac043db9d5"
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
