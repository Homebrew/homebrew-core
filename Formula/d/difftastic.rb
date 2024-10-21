class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.60.0.tar.gz"
  sha256 "4346b269240f3beff153758d0a2313accc79645ee21b36cfcc71ac0fca5d9b5d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14f2a72425f945b0855f1e7021956563eff649e325519b5d6cc2735148d8f6a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "650d4d17daef4d99562d582897f1b8a64c2bfebcf973ba043859cc60bd10beb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28a6e940acfed069a54352e0c49dbfda52754aa139647c4f9821bb4f146b8a77"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce45b9d84aef02b281b49c1eb816d22ff5bdfd85fe0e6d7b2ea362ba9645a60c"
    sha256 cellar: :any_skip_relocation, ventura:       "fffb7d1e13956f15d530774293e3456f50b283caf438d159cdec0f76149d5231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2afe65b490a5570409c603ea7375a13ce390d0c6e09242d41c493470a56dd4a"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "difft.1"
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
