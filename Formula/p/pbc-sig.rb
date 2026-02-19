class PbcSig < Formula
  desc "Signatures library"
  homepage "https://crypto.stanford.edu/pbc/sig/"
  url "https://crypto.stanford.edu/pbc/sig/files/pbc_sig-0.0.8.tar.gz"
  sha256 "7a343bf342e709ea41beb7090c78078a9e57b833454c695f7bcad2475de9c4bb"
  license "GPL-3.0-only"

  livecheck do
    url "https://crypto.stanford.edu/pbc/sig/download.html"
    regex(/href=.*?pbc_sig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "8440397e7b7310071d6ea7b5d9696d3f714e6b5cc0a49e87b9f2d8eb76d3959e"
    sha256 cellar: :any,                 arm64_sequoia:  "9af9663103707abefc59beba05f6b9e61d969944c35fb504245e9642c5d46d26"
    sha256 cellar: :any,                 arm64_sonoma:   "46b23a98ac077bfdf022b651cd1c0d465cf1a9a2e80780b024f7c4bb0df3f9ad"
    sha256 cellar: :any,                 arm64_ventura:  "a084822aa386425d1956ac3afdf2accbb8c813d371bbb20711e0f1d147f560ef"
    sha256 cellar: :any,                 arm64_monterey: "d2fde3522eb0285c965608483e1099f231df57528446ce3ebc59cee147459d58"
    sha256 cellar: :any,                 arm64_big_sur:  "f99446bcb7e5930651fc63d4a6bea1b34b489e13ad7318a026d0be3ed6fe39f9"
    sha256 cellar: :any,                 sonoma:         "0ee9c968c5718f7742607473b2284e92acaf032cf78bc4195d8fd48299d2c89f"
    sha256 cellar: :any,                 ventura:        "8842495f3027ac174ab9c9118b3d5c32c87c197fbdb070e7f19308ad251b7947"
    sha256 cellar: :any,                 monterey:       "49ba0b0e8757276a5ab822f942f321e7fe5b7efbb2340946e21f3042dbe579bd"
    sha256 cellar: :any,                 big_sur:        "9889f70fc5cf42a096c750b61008bf48a97bfece6179db5e7a631010749f1106"
    sha256 cellar: :any,                 catalina:       "47773fefdfeb3f7381046934974bbaf7f41a641c3d3f3af5802d07a7ea340ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "aa052f077db5ddb6e5a54e6b3fa56e350ca6877f208b0636cd703e63de2307d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c1de36643e895261969f7c184fabb031cc2eae412846409a778b21290670d45"
  end

  depends_on "gmp"
  depends_on "pbc"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  # https://groups.google.com/forum/#!topic/pbc-devel/ZmFCHZmrhcw
  patch :DATA

  def install
    # Disable -fnested-functions CFLAG on ARM, which will cause it to fail with:
    # incompatible redeclaration of library function 'pow'
    # Reported upstream here: https://groups.google.com/g/pbc-devel/c/WXwVWKoouj0.
    inreplace "configure", "-fnested-functions", "" if OS.mac?

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <pbc/pbc.h>
      #include <pbc/pbc_sig.h>

      int main()
      {
        pbc_param_t param;
        pairing_t pairing;
        bls_sys_param_t bls_param;
        pbc_param_init_a_gen(param, 160, 512);
        pairing_init_pbc_param(pairing, param);
        bls_gen_sys_param(bls_param, pairing);
        bls_clear_sys_param(bls_param);
        pairing_clear(pairing);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{Formula["pbc"].lib}",
                   "-L#{lib}", "-lpbc", "-lpbc_sig"
    system "./test"
  end
end

__END__
diff --git a/sig/bbs.c b/sig/bbs.c
index ed1b437..8aa8331 100644
--- a/sig/bbs.c
+++ b/sig/bbs.c
@@ -1,4 +1,5 @@
 //see Boneh, Boyen and Shacham, "Short Group Signatures"
+#include <stdint.h>
 #include <pbc/pbc_utils.h>
 #include "pbc_sig.h"
 #include "pbc_hash.h"
