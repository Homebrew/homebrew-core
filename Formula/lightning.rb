class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "https://ftp.gnu.org/gnu/lightning/lightning-2.2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/lightning/lightning-2.2.1.tar.gz"
  sha256 "98671681d5684770ccb06a07fa3b8f032a454bdb56eafc18e6fab04459ea3caa"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 ventura:      "c1eb8a8186bfa1a23a357a3d792b093daab48befead6f28c9a116b7efaee2e21"
    sha256 cellar: :any,                 monterey:     "1ae424e59729ac28174ea1c2bf97e9699b8f7f341d284e642ad7048ef6f091b2"
    sha256 cellar: :any,                 big_sur:      "356eae8409bf6dc18fb3539c82b2c968933f496a12a54b14cfbcf86a18c9c3e0"
    sha256 cellar: :any,                 catalina:     "ab244b3c017f380559a64d800add95a473de72cde9bd8a1e6a42c445b3c19b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b3d5c7288db4d78fefc35ba7f076200dc75c24c944593e2e0f821a9ddb90512e"
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
