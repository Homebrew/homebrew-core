class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.4.1.tar.gz"
  sha256 "ea829e1766c13c6813cecc6e9f492746e4b38304b05c742013b5504454d73d2b"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "882fc74629efc27e7c8c691a511c5d4d2091fe96a893fab4d0bf9547dc185710"
    sha256 cellar: :any_skip_relocation, catalina: "2b4a18325a045efb0d0e006a6824981b3d82e65d7c047690026c32de345f6c0b"
    sha256 cellar: :any_skip_relocation, mojave:   "63b135ddfc7dbaf6741c969feead0226a4884879dd183c3ee498bfa3e67f869c"
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
