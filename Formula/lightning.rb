class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "https://ftp.gnu.org/gnu/lightning/lightning-2.1.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/lightning/lightning-2.1.3.tar.gz"
  sha256 "ed856b866dc6f68678dc1151579118fab1c65fad687cf847fc2d94ca045efdc9"

  bottle do
    cellar :any
    sha256 "543bb685d72b8e9b10b14f3dcd615d38f8f499d10e1d27e40604240fc3f65ac3" => :catalina
    sha256 "c767959e901e6f47f9bbfe243e629508edbdb138376443d7943c4c4a5a52d4f2" => :mojave
    sha256 "da42166b5dd858cad42eeb7fc69a9ef870d23b67da6fa978d4bc58d3a464a0d4" => :high_sierra
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
