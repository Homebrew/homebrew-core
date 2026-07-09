class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v15.4.0.tar.gz"
  sha256 "a014951b2f1f12979a545b5b27b14c6254b16444aa5b59269e102773fd3669d9"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "882e3cc1448fdd855756b804ae66716f446e49c733e25a68b873efe411ebe98a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "882e3cc1448fdd855756b804ae66716f446e49c733e25a68b873efe411ebe98a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "882e3cc1448fdd855756b804ae66716f446e49c733e25a68b873efe411ebe98a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e72caf6e5c7df5568ea6e0e52972b8d20597902369cc0f1a85eb9225fe1e17f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "436055acba565f508b5a486767d62e7d393ba515fd6b2fb8922f75e24b223551"
    sha256 cellar: :any,                 x86_64_linux:  "b24b7ce0aa922c596a80e1d1da792c2a11434d4a09f1d5cacedb7572c4036cae"
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
