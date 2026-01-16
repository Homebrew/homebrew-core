class Libfreefare < Formula
  desc "API for MIFARE card manipulations"
  homepage "https://github.com/nfc-tools/libfreefare"
  url "https://github.com/nfc-tools/libfreefare/releases/download/libfreefare-0.4.0/libfreefare-0.4.0.tar.bz2"
  sha256 "bfa31d14a99a1247f5ed49195d6373de512e3eb75bf1627658b40cf7f876bc64"
  license "LGPL-3.0-or-later"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9db2e4002368c2b87fb707952d9272b740078176b456920a5d5181019617b2dd"
    sha256 cellar: :any,                 arm64_sequoia:  "2a601550aaba3113176cbb9c284f263faab1cacdadaa841ca48ffac4cc36ea70"
    sha256 cellar: :any,                 arm64_sonoma:   "be04856cd0edfb30a50104ea7fd3a5b7ce66c25921179415eddd8542b328d3a0"
    sha256 cellar: :any,                 arm64_ventura:  "6d9f13777430e1e406a80bb919603e2e1f823a84628ff9a6c27786e97077015b"
    sha256 cellar: :any,                 arm64_monterey: "dd6a7123a899f9ea2e0f2f1bb96ee61510d384db5dcda776968e5f642cdb3b1a"
    sha256 cellar: :any,                 arm64_big_sur:  "07bb6816871ab4f86df23f9929b7f5830b3203ee8573c61c1162155665be1cf6"
    sha256 cellar: :any,                 sonoma:         "cf47d28d3d12d295a911f266dcc2f1b124d333200214b835e41ae8d19f22c28a"
    sha256 cellar: :any,                 ventura:        "9bdc20fc20c01740f5e5c9f038e475f5ca940bf53f106884c5efa2a8b9bf78f5"
    sha256 cellar: :any,                 monterey:       "e88a2a0561e9bd91bcdda69fdec347abfa715876a540da3f5e12d71488ad4921"
    sha256 cellar: :any,                 big_sur:        "caf07c0af324770ece19c45f53697c88cedc651cad24c66e257fbb7b87391fc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7d7bc10990f7f8f1e0a2d2ff7888f98176bfcc2ef4f19aee6c9465a46947dfb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3837eb7894980557e16a097e05bc2fa8d42429177f30359166820cca640cc52"
  end

  depends_on "pkgconf" => :build
  depends_on "libnfc"
  depends_on "openssl@3"

  on_macos do
    depends_on "libusb-compat"
  end

  # Upstream commit for endianness-related functions, fixes
  # https://github.com/nfc-tools/libfreefare/issues/55
  patch do
    url "https://github.com/nfc-tools/libfreefare/commit/358df775.patch?full_index=1"
    sha256 "20d592c11e559d0a5f02f7ed56da370e39439feebd971be11b064d58ea85777f"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <freefare.h>
      int main() {
        mifare_desfire_aid_new(0);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lfreefare", "-o", "test"
    system "./test"
  end
end
