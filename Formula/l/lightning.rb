class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "https://ftp.gnu.org/gnu/lightning/lightning-2.2.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/lightning/lightning-2.2.2.tar.gz"
  sha256 "0aca8242dead17d62117bcfcb078e6a9ea856cc81742813c9e8394bcce73b3e2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 sonoma:       "099e81b84e2fc1a31b43d316df2768dfa6441e55aca90e8113fe18772c3f611e"
    sha256 cellar: :any,                 ventura:      "05f528061480f85ae5451ad09770f5a44e60388f9cae719735640c8819e2970b"
    sha256 cellar: :any,                 monterey:     "8ba3c1335a85fa0d61611fa0bf5aa73ae9628afb412a3e5a60f6cb847802ba30"
    sha256 cellar: :any,                 big_sur:      "dd12b9fd6a87b5ecbca432211b26c26f3ca8fb1b032e4d61a144d38a2ca14bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e21fe40273d1926784788c2cbb0627611e37089a4a1ec48388fcaf4ffb77c5ba"
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
