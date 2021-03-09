class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.5.0.tar.gz"
  sha256 "3843d1e03ba23297dcd598820af43df92791265d012cdcc14f313f1ba6013ffa"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "8f056b212b4030f5cb4c007f39ba13dd199c1439ecaf4ee415e212a08fed0182"
    sha256 cellar: :any_skip_relocation, catalina: "9598cb8eabd2a7b7b3e59a85b1b580129c49c9654e4d9d358553a87133f6ab1c"
    sha256 cellar: :any_skip_relocation, mojave:   "26664b499d3f4032ae2b66263ebf6324099175c00e25bb5b7530b1fcfc29220b"
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
