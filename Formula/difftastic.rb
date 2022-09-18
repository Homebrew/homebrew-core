class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.36.0.tar.gz"
  sha256 "9eb2a3766cb992126fefbd7ea7d8fcc9cfc75ee1f8111fb7348e56aa46d72459"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "639134ef070c4af64c2b5de0239df5438658f212ee89463f8ccf3b795b7a37d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa91eff089c38fca07015ec57fa11ac31e3c2142abc947470af9e6a61b765940"
    sha256 cellar: :any_skip_relocation, monterey:       "e43f7555257677498fa155d72f619b880941520192f01e27e21de4a5cfedc1f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "50c76baaa7f91db2869c3dc63eb7bd710f4e958f68a70511f84de0d0b7372d63"
    sha256 cellar: :any_skip_relocation, catalina:       "3f03d702bb358c8bbf1a151a1fd2636579477c8da35d76d5814513ac982e1b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f75d08c5ea1ca553afb6114ba4ff3c219d512319ff2b1602bec0b30ce4e9b1a1"
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
      1 print(42) 1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
