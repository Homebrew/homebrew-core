class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.26.3.tar.gz"
  sha256 "9d4e026032738b3ffff35f8f2c775f82d6c4604892f17cbbd0106760a80deb91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9bcfacb39cf1e996e1870cae6b4fc91e83eb5169434ae6d1c80757ab49f0c67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7e837c05194f6c652d6ce182a9c8cc1951b95a30bd743ad555ac7349aec7fec"
    sha256 cellar: :any_skip_relocation, monterey:       "65bec6eb8d1b11189f4e0ec0bd7544df9e5c28396159740c1fa22fc3b9994037"
    sha256 cellar: :any_skip_relocation, big_sur:        "d58dbc397d5748c41b6c05e39022faf6fbc80b3a4b966dd0412f57e0ee40890d"
    sha256 cellar: :any_skip_relocation, catalina:       "b264b027121cac26a391285421ae595444dff0685edf523bc65fa9e14bd61d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00eed79802cd88ead6fb69a43f61399767cf6ba8eb6a4e3c3af9057a574d5525"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
