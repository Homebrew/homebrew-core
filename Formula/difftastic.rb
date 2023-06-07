class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.47.0.tar.gz"
  sha256 "ebbc0840da679573ea4f6a4fb5198b422550e8b6d3bb46cdcf019b777d08ea60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52542bacd4d6ebea4b092091d9bca89f6ccddaf1eb6d772293119e8b7f997a79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d4e6030d500ec12feac1808017b68ba27e913d5949cde35fc92df09def2567d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0198b8789c19da77b8813428688932b7fe381b76e67488654710460f29bf1e5"
    sha256 cellar: :any_skip_relocation, ventura:        "881b109277e04ad739641f48e7547373f8031c6a2fa98388cfb46ca6df6ab098"
    sha256 cellar: :any_skip_relocation, monterey:       "ede246ce9e803970a780eec91e7ad0e2f5478ec2d03e5647665d4d62c2e4bd96"
    sha256 cellar: :any_skip_relocation, big_sur:        "30c347bf2f13587d4741e42cc5baf3d86ad9237c88140078ce80ab3b6bd92082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fb73f2ffd7d773aa43ac5d103ca3dc9de5477dae8eaa10cc453c7d6694e299e"
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
