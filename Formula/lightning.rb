class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "https://ftp.gnu.org/gnu/lightning/lightning-2.2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/lightning/lightning-2.2.1.tar.gz"
  sha256 "98671681d5684770ccb06a07fa3b8f032a454bdb56eafc18e6fab04459ea3caa"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 ventura:      "6cfdce42d276b20be84388c1561e642d02ba3c5a774e784c825f86d64e477afc"
    sha256 cellar: :any,                 monterey:     "8703cdf9d13345a291aa234acf881ee2e275ecce02fe621f37e85a1fb2fed2c6"
    sha256 cellar: :any,                 big_sur:      "d6dbe3db3b24560eb205afc6d8502a5f172ac376b819bcf2a9b67ab372520e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d3b2f4bb85635595ec3eb7ef54991e61780f73208f5a27e5cbaaaa2bc1f0c7e5"
  end

  depends_on "binutils" => :build
  depends_on arch: :x86_64

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # from https://www.gnu.org/software/lightning/manual/lightning.html#incr
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <lightning.h>
      static jit_state_t *_jit;
      typedef int (*pifi)(int);
      int main(int argc, char *argv[]) {
        jit_node_t  *in;
        pifi incr;
        init_jit(argv[0]);
        _jit = jit_new_state();
        jit_prolog();
        in = jit_arg();
        jit_getarg(JIT_R0, in);
        jit_addi(JIT_R0, JIT_R0, 1);
        jit_retr(JIT_R0);
        incr = jit_emit();
        jit_clear_state();
        printf("%d + 1 = %d\\n", 5, incr(5));
        jit_destroy_state();
        finish_jit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-llightning", "-o", "test"
    system "./test"
  end
end
