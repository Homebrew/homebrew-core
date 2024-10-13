class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.60.0.tar.gz"
  sha256 "4346b269240f3beff153758d0a2313accc79645ee21b36cfcc71ac0fca5d9b5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3459cfbf05198892bde68adfcc31a41fd333e99d230d704525759f69cf33d5a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "961992175d726fc32b73eb2e5261872ac321d1086ebddc606f7fa60bfb4cee87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a403220d743c7f595fc3082862cc0dab71a19384af81ef18d8f52ceb8c6303f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be1bc03b621bd2fddeb8d931510b709ca8a80a76c2f2d65c0c669f2aa1232db7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f576a302370c4be84e4dee0309e3822a15a119c4e89a1b5f21eaf36e69f9e15"
    sha256 cellar: :any_skip_relocation, ventura:        "3b536478a605706b688aa6534804ea3858b916c70134080d4ef2c1c07175b323"
    sha256 cellar: :any_skip_relocation, monterey:       "1d6a7072914ed8b9f7f4b2d76e41d95434ba94628d7a714eb03f8f02df2d02c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e4dda746d0880f3a4618e48f42b1ec9665bb5a626a12328804a9e923dec3985"
  end

  depends_on "rust" => :build

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
