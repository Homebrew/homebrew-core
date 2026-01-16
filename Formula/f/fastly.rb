class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v13.3.0.tar.gz"
  sha256 "df19f75923822e47ef36b81ab5130ba88cc1fa63aea310b0e53e1bc20a3c04a9"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b22e80bff239df81a5185aa2f9344d4b8c9c439365f5e8687f1edfc19fc96083"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b22e80bff239df81a5185aa2f9344d4b8c9c439365f5e8687f1edfc19fc96083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b22e80bff239df81a5185aa2f9344d4b8c9c439365f5e8687f1edfc19fc96083"
    sha256 cellar: :any_skip_relocation, sonoma:        "f516269a01bf50af3f1cb4e319c8c58a8862f4528b8eeee83001aa8e2a6e1aaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3713303baebbd6392aff38722fdafdd243a88af5a28da519b91da63c6699793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76fbe3ed7e8ad7b35bcb56540179391c9d6b8b82cbdf77596b31f1229f519106"
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
