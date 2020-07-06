class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.3.6.tar.gz"
  sha256 "9f5b4e500374142098bf30274d69375507b6c3e44f653d518b61cdddae646a83"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7d63dcd10594d659d950e8edb23dd189f56a1d887ac26f368c720feb91e674d" => :catalina
    sha256 "6b9aaf79b508a63fd12311aae7d2631d45c08ab194802997d80832d530391763" => :mojave
    sha256 "2551762505c66f37a181dbd5133fefb9bb92c6ed4e68a992f54db7e89be8a50f" => :high_sierra
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
