class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.65.0.tar.gz"
  sha256 "59462f69e2cedfdc1bee4fd0da48fe9a7ae635cdb6818c1a300b31c0b146d4b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f53e8f71743e6c8d312daa0375f37552c31cd65f36070c910d96754bbd913d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e225ac22a393818486adc2c4e8b9d72dc9f5d328fbc756b355af9ebb5a36e2bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c84ded23370cf25a87f1a0f95b3cbddec3399a15acccbbd8fbd746e3e60e3ae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "74adcd8017f76c8abfe4890c357ca6d72e86029b97eefbd534b993147ba48d33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28ee881d685edcd4312f2bd845d51fa48459104b8ee120baff5741a460347ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84be8f22e67c13db6bc1e162af3899eaf897160280901d2f07b0dd0ccd504502"
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
      1 print(42)                   1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
