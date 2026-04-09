class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v14.2.0.tar.gz"
  sha256 "28fbb1f62be60a75036c15a6e263ef16af09d2eaab3ab6063642d6e6c23db6f0"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8bb33c69475dc348f60ee04b518f65b3ac5eb3542a5f37e5714dec89ff8e2d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8bb33c69475dc348f60ee04b518f65b3ac5eb3542a5f37e5714dec89ff8e2d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8bb33c69475dc348f60ee04b518f65b3ac5eb3542a5f37e5714dec89ff8e2d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d21a49ded1d3fa4a16ecf039b1a972c135d353c5071ddfe4992304d4c1362b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd8e70a9606944aaf12a717484cc49b99fa1e8eb2960a03fe23fe9123fd5bd3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75c407119735c57d10d8439957487e36e847e39125b1a16833f6b629a80d0a91"
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
