class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "https://ftp.gnu.org/gnu/lightning/lightning-2.1.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/lightning/lightning-2.1.3.tar.gz"
  sha256 "ed856b866dc6f68678dc1151579118fab1c65fad687cf847fc2d94ca045efdc9"

  bottle do
    cellar :any
    sha256 "1eae478d637843e90a1d6ad9597f8479ab79dda1e56fd12b37428f7d5c8c5a15" => :mojave
    sha256 "ed3fb8e5552f78ef17fa4a5eab54a69068113c28f50723e2a9d9fa68ca9a554d" => :high_sierra
    sha256 "b3898ab467ddc57c03f72615e95fedadf4bbf249ba76ed9de8cc410efe58b114" => :sierra
    sha256 "ddea1c93ea261eb8f49f998deb8769b8b67d44ec955e6dbbe8509d90f5ae9b6e" => :el_capitan
  end

  depends_on "binutils" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "check", "-j1"
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
