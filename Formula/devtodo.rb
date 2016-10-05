class Devtodo < Formula
  desc "Command-line task lists"
  homepage "http://swapoff.org/DevTodo"
  url "http://swapoff.org/files/devtodo/devtodo-0.1.20.tar.gz"
  sha256 "379c6ac4499fc97e9676075188f7217e324e7ece3fb6daeda7bf7969c7093e09"
  revision 1

  bottle do
    sha256 "0eba33a6154e4c1a77c7253c11b3d5f4366e692496e8ae32db986e24a0a5d5e4" => :sierra
    sha256 "e11b6bf766ba86aa6eb92e2d1b018a0608766ba6b2c38db55b335664d415ad57" => :el_capitan
    sha256 "f97442776b7d80a7ef7b8b750086e3e936c297e78cac75ccbae16d14506d7e05" => :yosemite
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
