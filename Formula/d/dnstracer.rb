class Dnstracer < Formula
  desc "Trace a chain of DNS servers to the source"
  homepage "http://www.mavetju.org/unix/dnstracer.php"
  url "http://www.mavetju.org/download/dnstracer-1.9.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/d/dnstracer/dnstracer_1.9.orig.tar.gz"
  sha256 "2ebc08af9693ba2d9fa0628416f2d8319ca1627e41d64553875d605b352afe9c"
  license "BSD-2-Clause"

  # It's necessary to check the `/unix/general.php` page, instead of
  # `/download/`, until a real 1.10 version exists. The file name for version
  # 1.1 on the `/download/` page is given as 1.10 and this is erroneously
  # treated as newer than 1.9.
  livecheck do
    url "http://www.mavetju.org/unix/general.php"
    regex(/href=.*?dnstracer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "bf4002b2b3c7b6e94bfbd23130cae602e9e7c7d9e3145b7210cbc4fc574b5004"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "154b03978527a24ea93fa486de2f90f51bba19a873cd8fc7760027b7cf9e965d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9f0cef649625b90f8b813401e0cee3b0d26abb2ad5eabdb8b80bea6d93106d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c90d0674735e546310ec3e6052242171258f29faf127138282ea4e396946d737"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07ec9123818d074dcbd378fc46fcf0bf17557f1f4ceccb631aef4669af57373d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc60fdb473c11615a27f62abb5aba5ae0a270c4b3d33001c07668266254c7486"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0bda5093f4ee8d73bca5c7609769fb9b5a85509b8ffb3f981b5cadd299b838f"
    sha256 cellar: :any_skip_relocation, ventura:        "1e163d7856ec1f1d8a420f080ad6d1593c8c0977c1f3d1c22b9c19728abe4094"
    sha256 cellar: :any_skip_relocation, monterey:       "3d7210cdf69f4ebae90e2a1b65729dce288b4dab03a921d64d521ac9e137dfd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6e0d89127fbc47d2b30cd7d2918279f858a79d87b2e32e63cccfcc4f92f3495"
    sha256 cellar: :any_skip_relocation, catalina:       "953752b2c3a012b0e92cd6fc78ef47d7b585e9a3034ef667a9ce3d353c4bb1db"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "396697504e1ed5de305ae93a03540549bde4be87839036df19439584a39dcdfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a8f70b7d7d09e10e995f908c4b581a9d3f2ea201719e768e7e65c022f8eb7d"
  end

  # Fix to error: conflicting types for 'res_9_getlong', 'res_9_getshort'
  patch :DATA if DevelopmentTools.clang_build_version >= 1700

  def install
    ENV.append "LDFLAGS", "-lresolv"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"dnstracer", "-4", "brew.sh"
  end
end

__END__
diff --git a/dnstracer.c b/dnstracer.c
index 167342a..2a30d53 100644
--- a/dnstracer.c
+++ b/dnstracer.c
@@ -48,6 +48,13 @@
     #include <arpa/nameser.h>
     #include <netdb.h>
     #include <resolv.h>
+
+    #ifdef getlong
+    #  undef getlong
+    #endif
+    #ifdef getshort
+    #  undef getshort
+    #endif
 #endif
 
 #include <sys/types.h>

