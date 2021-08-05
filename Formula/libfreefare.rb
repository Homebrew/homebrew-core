class Libfreefare < Formula
  desc "API for MIFARE card manipulations"
  homepage "https://github.com/nfc-tools/libfreefare"
  url "https://github.com/nfc-tools/libfreefare/releases/download/libfreefare-0.4.0/libfreefare-0.4.0.tar.bz2"
  sha256 "bfa31d14a99a1247f5ed49195d6373de512e3eb75bf1627658b40cf7f876bc64"
  license "LGPL-3.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c66fe7ad412745ebd9c10784f9ef7de563a5c1ef7582a72915ad7b50324a65c5"
    sha256 cellar: :any,                 big_sur:       "bcc9bf9b7c9ee53de79b4784264c0923587b48933d2a6c1f57730fd359f8646d"
    sha256 cellar: :any,                 catalina:      "5019ddb58b52c0ef766c331273c73ca4a374e87d5288d7357cd7e965150b43c4"
    sha256 cellar: :any,                 mojave:        "a039acfcd35d2763313e47dd0175474975ffdecba60f6c6af714f7b0f0630144"
    sha256 cellar: :any,                 high_sierra:   "5ae1a6b59880a6ae25ce53cfe9727be4cdf5a9cd5fe28c06f7bbc0e3d1342939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ae1a1c73009d57d49c65f86b402dfeb94aaffabbe1a29cd7b7752595fdf05fd"
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "openssl@1.1"

  # Upstream commit for endianness-related functions, fixes
  # https://github.com/nfc-tools/libfreefare/issues/55
  patch do
    url "https://github.com/nfc-tools/libfreefare/commit/358df775.patch?full_index=1"
    sha256 "20d592c11e559d0a5f02f7ed56da370e39439feebd971be11b064d58ea85777f"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <freefare.h>
      int main() {
        mifare_desfire_aid_new(0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lfreefare", "-o", "test"
    system "./test"
  end
end
