class Fbida < Formula
  desc "View and edit photo images"
  homepage "https://linux.bytesex.org/fbida/"
  url "https://dl.bytesex.org/releases/fbida/fbida-2.13.tar.gz"
  sha256 "a887195dcd189055ee9b787eb03c8b7954df3aec540a1f90d8e92f873126db07"

  bottle do
    cellar :any
    sha256 "93406f2444f68f31a202ad8c1a6de5f5bf6b49a5578557e7a84966694b7eda2e" => :sierra
    sha256 "a995d8758481ecfea43cb0b750c3fb55a2fd5245c05e9a4fa8c7678f24557715" => :el_capitan
    sha256 "217a0619bff984cd675945199d6e8fb438265541a298109051e3ab6508226fd5" => :yosemite
  end

  depends_on "libexif"
  depends_on "jpeg"

  # Fix issue in detection of jpeg library
  patch :DATA

  def install
    ENV.append "LDFLAGS", "-liconv"
    system "make"
    bin.install "exiftran"
    man1.install "exiftran.man" => "exiftran.1"
  end

  test do
    system "#{bin}/exiftran", "-9", "-o", "out.jpg", test_fixtures("test.jpg")
  end
end

__END__
diff --git a/GNUmakefile b/GNUmakefile
index 2d18ab4..5b409fb 100644
--- a/GNUmakefile
+++ b/GNUmakefile
@@ -30,7 +30,7 @@ include $(srcdir)/mk/Autoconf.mk
 
 ac_jpeg_ver = $(shell \
 	$(call ac_init,for libjpeg version);\
-	$(call ac_s_cmd,echo JPEG_LIB_VERSION \
+	$(call ac_s_cmd,printf JPEG_LIB_VERSION \
		| cpp -include jpeglib.h | tail -n 1);\
 	$(call ac_fini))
 
