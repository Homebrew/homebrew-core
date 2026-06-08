class Pop < Formula
  desc "Send emails from your terminal"
  homepage "https://github.com/charmbracelet/pop"
  url "https://github.com/charmbracelet/pop/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "365b989dcd0c45256e304ddd8e7a4be8ac146ed24a5751930259c56c23a16dec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15bf4e71c44dc1941a56c5f2ed7f073e7b5cd8c58aa62d053a8d6544f25e68a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15bf4e71c44dc1941a56c5f2ed7f073e7b5cd8c58aa62d053a8d6544f25e68a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15bf4e71c44dc1941a56c5f2ed7f073e7b5cd8c58aa62d053a8d6544f25e68a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "341a35f0e46f9e161a3aba9f12072485c498f5e832863345b9be443018d1427d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d2dbc83e39eed8dc8d69cf0e513d8e304f0730f34cc21873b05a81e63660da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3314c12b863cc246833842eda33f371255dae1ddfdcfeff4c0368b1226a82da6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pop", shell_parameter_format: :cobra)
    (man1/"pop.1").write Utils.safe_popen_read(bin/"pop", "man")
  end

  test do
    assert_match "environment variable is required",
      shell_output("#{bin}/pop --body 'hi' --subject 'Hello'", 1).chomp

    assert_match version.to_s, shell_output("#{bin}/pop --version")
  end
end
