class Devtodo < Formula
  desc "Command-line task lists"
  homepage "https://swapoff.org/devtodo.html"
  url "https://swapoff.org/files/devtodo/devtodo-0.1.20.tar.gz"
  sha256 "379c6ac4499fc97e9676075188f7217e324e7ece3fb6daeda7bf7969c7093e09"
  revision 2

  bottle do
    sha256 "24cc0693b8b69ac2fe7d926cbc3b8fae6e09df83b6a979ac71c68b8ae5ee6196" => :catalina
    sha256 "80c04083f48a5791985a5cf02e86ddff3e40b4523177a947f0bd3f7f066f47a1" => :mojave
    sha256 "1d5279b22730d8983887f91866a913b4714f8e453e382116bee294bbacee0e97" => :high_sierra
    sha256 "aa22627fa7722dd0ca564fdd9770a047901d71090bb5312edfa91c8cf0d72ba4" => :sierra
  end

  depends_on "readline"

  conflicts_with "todoman", :because => "both install a `todo` binary"

  # Fix invalid regex. See https://web.archive.org/web/20090205000308/swapoff.org/ticket/54
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

  test do
    (testpath/"test").write <<~EOS
      spawn #{bin}/devtodo --add HomebrewWork
      expect "priority*"
      send -- "2\r"
      expect eof
    EOS
    system "expect", "-f", "test"
    assert_match "HomebrewWork", (testpath/".todo").read
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
