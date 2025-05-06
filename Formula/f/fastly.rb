class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v11.2.0.tar.gz"
  sha256 "42e79c7059050baaed8b9b506962d98d29142ba26cf899e82a94f5bb72c04c90"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71dcb57dca2a970435b06d71347ecae78704e542ab9cc29ac1a47f5fed274f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71dcb57dca2a970435b06d71347ecae78704e542ab9cc29ac1a47f5fed274f8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71dcb57dca2a970435b06d71347ecae78704e542ab9cc29ac1a47f5fed274f8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "69ad7d3e1fcbe3cc457c70610acf9e13ae27c21d462c19740e140b655c44fbee"
    sha256 cellar: :any_skip_relocation, ventura:       "69ad7d3e1fcbe3cc457c70610acf9e13ae27c21d462c19740e140b655c44fbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a43bdcf754986dd3484e56d201bffbb965c6b2edb032eb2fc1bf55583a76d9b8"
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

    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "Fastly API returned 401 Unauthorized", output
  end
end
