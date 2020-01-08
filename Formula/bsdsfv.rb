class Bsdsfv < Formula
  desc "SFV utility tools"
  homepage "https://bsdsfv.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bsdsfv/bsdsfv/1.18/bsdsfv-1.18.tar.gz"
  sha256 "577245da123d1ea95266c1628e66a6cf87b8046e1a902ddd408671baecf88495"

  bottle do
    cellar :any_skip_relocation
    sha256 "3abfd33001c44edc6b03905559f8565f923001aa1ccc3a3247ebd073d226ccaa" => :catalina
    sha256 "e500396c1a26993727df9ccc8d878e0a4fbc353326206dffcbd18b9fc8071247" => :mojave
    sha256 "28bee35fbc8c0be9e1182287c58340898d29d9ba0f910109974af6efcb5cd61f" => :high_sierra
    sha256 "38b9d278b430e250b384c5ba2baf3e74dfe0771c5ceea45686022ecb01616ee2" => :sierra
    sha256 "404ec03e044a019a487adfab90012a29a6655fe67b907d9b4e9a46d4f6c57a9b" => :el_capitan
    sha256 "fd15cb46a9499bcd1182e8fe4a6ae1de9fb77ced85186601ef6c6579a22d9c51" => :yosemite
    sha256 "7d0590952682b7baf619122a2942dacbf7ed455263c49b0314a85be7d51b1dc1" => :mavericks
  end

  # bug report:
  # https://sourceforge.net/p/bsdsfv/bugs/1/
  # Patch from MacPorts
  patch :DATA

  def install
    bin.mkpath

    inreplace "Makefile" do |s|
      s.change_make_var! "INSTALL_PREFIX", prefix
      s.change_make_var! "INDENT", "indent"
      s.gsub! "	${INSTALL_PROGRAM} bsdsfv ${INSTALL_PREFIX}/bin", "	${INSTALL_PROGRAM} bsdsfv #{bin}/"
    end

    system "make", "all"
    system "make", "install"
  end
end

__END__
--- a/bsdsfv.c	2012-09-25 07:31:03.000000000 -0500
+++ b/bsdsfv.c	2012-09-25 07:31:08.000000000 -0500
@@ -44,5 +44,5 @@
 typedef struct sfvtable {
	char filename[FNAMELEN];
-	int crc;
+	unsigned int crc;
	int found;
 } SFVTABLE;
