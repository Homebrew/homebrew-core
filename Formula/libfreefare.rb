class Libfreefare < Formula
  desc "API for MIFARE card manipulations"
  homepage "https://github.com/nfc-tools/libfreefare"
  url "https://github.com/nfc-tools/libfreefare/releases/download/libfreefare-0.4.0/libfreefare-0.4.0.tar.bz2"
  sha256 "bfa31d14a99a1247f5ed49195d6373de512e3eb75bf1627658b40cf7f876bc64"
  license "LGPL-3.0"
  revision 3

  bottle do
    cellar :any
    sha256 "5019ddb58b52c0ef766c331273c73ca4a374e87d5288d7357cd7e965150b43c4" => :catalina
    sha256 "a039acfcd35d2763313e47dd0175474975ffdecba60f6c6af714f7b0f0630144" => :mojave
    sha256 "5ae1a6b59880a6ae25ce53cfe9727be4cdf5a9cd5fe28c06f7bbc0e3d1342939" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "openssl@1.1"

  # Upstream commit for endianness-related functions, fixes
  # https://github.com/nfc-tools/libfreefare/issues/55
  patch do
    url "https://github.com/nfc-tools/libfreefare/commit/358df775.diff?full_index=1"
    sha256 "54cace0b9f7be073ba96ba1ae04fba8882a5ce99100a7b707498b9d2bfb0a660"
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
