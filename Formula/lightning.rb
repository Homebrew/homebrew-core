class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "https://ftp.gnu.org/gnu/lightning/lightning-2.1.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/lightning/lightning-2.1.2.tar.gz"
  sha256 "9b289ed1c977602f9282da507db2e980dcfb5207ee8bd2501536a6852a157a69"

  bottle do
    cellar :any
    rebuild 2
    sha256 "0f8883b4b47ad82796587ec62285c371144d733cbe795db4e9b7c09872a6ebad" => :sierra
    sha256 "34f86d2f39e14f17aaf7fe51e84351f86f23ce4898b1e200694917f24ac7db55" => :el_capitan
    sha256 "985f3b7ba1060b88eb98698dd912d24c11a874dc949b9ffc221bff310a98736f" => :yosemite
    sha256 "816ac38c2ef65ba50247b9c31ad310f610ef26c490be12cb3fb03f4ef5418b6e" => :mavericks
  end

  depends_on "binutils" => [:build, :optional]

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]
    args << "--disable-disassembler" if build.without? "binutils"

    system "./configure", *args
    system "make", "check", "-j1"
    system "make", "install"
  end

  test do
    # from https://www.gnu.org/software/lightning/manual/lightning.html#incr
    (testpath/"test.c").write <<-EOS.undent
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
