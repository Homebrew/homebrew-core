class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "https://ftp.gnu.org/gnu/lightning/lightning-2.2.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/lightning/lightning-2.2.0.tar.gz"
  sha256 "4e3984ff1ccf0ba30a985211d40fc5c06b25f014ebdf3d80d0fe3d0c80dd7c0e"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any,                 monterey:     "df861eb96cff6fbc36ebc4d2658e1bf49fddc55b0cc99769ffd050284d8b4257"
    sha256 cellar: :any,                 big_sur:      "e4f321fb649fd5d039fce2c7a74eabf4cf2a05cd00d3934535f074af787a6188"
    sha256 cellar: :any,                 catalina:     "7de3685567fc48552bf4978a6e8cb56ef64f5fc19887afbabee132fe7278edc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5d43df0fe812648b1074edec1f534d95f82d2a27709618da727b3d66e64e0b99"
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
