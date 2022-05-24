class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.10.0.tar.gz"
  sha256 "5821c0aa5fdda9e84399a5f92dbab53be2dbbcd9a7d4c81166c0b224a38624f8"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/sharkdp/hexyl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "509d6a89942af5f03847b001080e58a5a80d4985552fe2eb3c2567a45291cedc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3ec37a1d0fa504e153c3e28549fa2e9b250232a0797a03fee38aa44e06fa7ea"
    sha256 cellar: :any_skip_relocation, monterey:       "daf860cbe43139bfdc33ccc06d3e6134252d1498d97cbaedd0e3cc1128c99d88"
    sha256 cellar: :any_skip_relocation, big_sur:        "32f0919b16859d9fa1259746eeba92f7be4a4a36455369c831b5edb5362ecc61"
    sha256 cellar: :any_skip_relocation, catalina:       "0a3921f9a55082a65c6aca3820f3c187d99b6b1c5da18ed792fac074f14b949b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac81155dc0210d8fdd28842b32430aff4b3f53e166432020ea5375e4b77b3e00"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "pandoc", "-s", "-f", "markdown", "-t", "man",
                     "doc/hexyl.1.md", "-o", "hexyl.1"
    man1.install "hexyl.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
