class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "ebb25a176925492909434919000a54f1592b3488c57fa83bfd324eb1fd71e9f5"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b463401496186b08b3f8125a679b4f432a5e040e0fc67a6bd9dcf0e00f732168"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cac7264e2f8d58924649092b078c6c43aaba936f468af96c0ebeee07400ab9f"
    sha256 cellar: :any_skip_relocation, monterey:       "1345964158b91507735f9dccdf1ac6420da2991613654b0f4ef84d0129848096"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c9a0461c41ba631853fe6e2100b558cbca6d4809e627186bb4c3f3790a0691f"
    sha256 cellar: :any_skip_relocation, catalina:       "056033a04399508bbc951977971f71afedec48d2e5fac6bc3dabc30f8287007c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efd7f65d3d5bd40f6bafc443d502a7469d796ec746ff3726b2a6395ea11bae9d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
