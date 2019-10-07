class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "https://www.colordiff.org/"
  url "https://www.colordiff.org/colordiff-1.0.18.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/colordiff-1.0.18.tar.gz"
  sha256 "29cfecd8854d6e19c96182ee13706b84622d7b256077df19fbd6a5452c30d6e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f3ca0480df2c98a43cba77638ca31d85a2450d6a536e3531f65345f42b07e53" => :catalina
    sha256 "63483bb1f9e86ffb85de6c7bfaba178da41e2f4577e58efd3d893d8b66263101" => :mojave
    sha256 "1b381f5726976016f7996abd414eb24b19bfd63dcc7a8a628e51ca4e3507b4d1" => :high_sierra
    sha256 "c4d57d0ae142725bd320600864843ce040457c7652a3e403e1c65a6e53b42afd" => :sierra
    sha256 "19c797b186c5b2ec4e4692a21d25f3c8e48addea3cc8aaa2809cf37dcc0f1100" => :el_capitan
    sha256 "19c797b186c5b2ec4e4692a21d25f3c8e48addea3cc8aaa2809cf37dcc0f1100" => :yosemite
  end

  conflicts_with "cdiff", :because => "both install `cdiff` binaries"

  patch :DATA

  def install
    man1.mkpath
    system "make", "INSTALL_DIR=#{bin}",
                   "ETC_DIR=#{etc}",
                   "MAN_DIR=#{man1}",
                   "install"
  end

  test do
    cp HOMEBREW_PREFIX+"bin/brew", "brew1"
    cp HOMEBREW_PREFIX+"bin/brew", "brew2"
    system "#{bin}/colordiff", "brew1", "brew2"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 6ccbfc7..e5d64e7 100644
--- a/Makefile
+++ b/Makefile
@@ -28,8 +29,8 @@ install:
 	if [ ! -f ${DESTDIR}${INSTALL_DIR}/cdiff ] ; then \
 	  install cdiff.sh ${DESTDIR}${INSTALL_DIR}/cdiff; \
 	fi
-	install -Dm 644 colordiff.1 ${DESTDIR}${MAN_DIR}/colordiff.1
-	install -Dm 644 cdiff.1 ${DESTDIR}${MAN_DIR}/cdiff.1
+	install -m 644 colordiff.1 ${DESTDIR}${MAN_DIR}/colordiff.1
+	install -m 644 cdiff.1 ${DESTDIR}${MAN_DIR}/cdiff.1
 	if [ -f ${DESTDIR}${ETC_DIR}/colordiffrc ]; then \
 	  mv -f ${DESTDIR}${ETC_DIR}/colordiffrc \
 	    ${DESTDIR}${ETC_DIR}/colordiffrc.old; \
@@ -37,7 +38,6 @@ install:
 	  install -d ${DESTDIR}${ETC_DIR}; \
 	fi
 	cp colordiffrc ${DESTDIR}${ETC_DIR}/colordiffrc
-	-chown root.root ${DESTDIR}${ETC_DIR}/colordiffrc
 	chmod 644 ${DESTDIR}${ETC_DIR}/colordiffrc

 uninstall:
