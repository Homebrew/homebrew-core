class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.67.0.tar.gz"
  sha256 "a6a15d6ca9f9ab7c034d1770417d1829deb3fbe9dcf4731b9cba867e50e78437"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41b43ca36a81709bbfb02b6a760ecd0c5a48931a534fadc1d3e921900ed61444"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e132f932ecb6d8dee3203c4907efc1e9bc1ca56e85b67f064ff74f6f06b3ad77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "401c38325d76090db94fd517b865f5a94e0a04ebfc1bbccff092bed641c2238d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0488707d086e79a839c484207a246cf1b0ad017ada8ad98b9049557a13d665f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5588b99c39afd7375c0ffdc6abf1c04d0d78c22075adb3964a1e36055a0c7ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7720915a13a06f8e765532669ff58f632d6ccab8f12e3c639421452f8f71111"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "difft.1"
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                 1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
