class Devtodo < Formula
  desc "Command-line task lists"
  homepage "http://swapoff.org/DevTodo"
  url "http://swapoff.org/files/devtodo/devtodo-0.1.20.tar.gz"
  sha256 "379c6ac4499fc97e9676075188f7217e324e7ece3fb6daeda7bf7969c7093e09"
  revision 1

  bottle do
    sha256 "5b7ec857a599dd407518e922a093a46d5a9af55ce8469915dcc94793c3700c5c" => :el_capitan
    sha256 "46f6beed006e560df7d1718b95706913d4d5e632ef200364abc1944890ccf412" => :yosemite
    sha256 "1d018bb98b87b4daaad1f89b74925e52ca07403e45efe884ced4b34db3f21f9e" => :mavericks
  end

  depends_on "readline"

  # Fix invalid regex. See http://swapoff.org/ticket/54
  # @adamv - this url not responding 3/17/2012
  patch :DATA

  def install
    # Rename Regex.h to Regex.hh to avoid case-sensitivity confusion with regex.h
    mv "util/Regex.h", "util/Regex.hh"
    inreplace ["util/Lexer.h", "util/Makefile.in", "util/Regex.cc"],
      "Regex.h", "Regex.hh"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
    doc.install "contrib"
  end
end

__END__
--- a/util/XML.cc	Mon Dec 10 22:26:55 2007
+++ b/util/XML.cc	Mon Dec 10 22:27:07 2007
@@ -49,7 +49,7 @@ void XML::init() {
 	// Only initialise scanners once
 	if (!initialised) {
 		// <?xml version="1.0" encoding="UTF-8" standalone="no"?>
-		xmlScan.addPattern(XmlDecl, "<\\?xml.*?>[[:space:]]*");
+		xmlScan.addPattern(XmlDecl, "<\\?xml.*\\?>[[:space:]]*");
 		xmlScan.addPattern(XmlCommentBegin, "<!--");
 		xmlScan.addPattern(XmlBegin, "<[a-zA-Z0-9_-]+"
 			"([[:space:]]+[a-zA-Z_0-9-]+=(([/a-zA-Z_0-9,.]+)|(\"[^\"]*\")|('[^']*')))"
