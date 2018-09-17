class John < Formula
  desc "Featureful UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://www.openwall.com/john/j/john-1.8.0.tar.xz"
  sha256 "952cf68369fb5b27f2d112ce7ca1eb16b975c85cbce8c658abb8bc5a20e1b266"

  bottle do
    cellar :any_skip_relocation
    sha256 "47b5ee6540c5840df7311cc03f898b57ad671f85a3ee9b2fc32084409602a3cf" => :mojave
    sha256 "92504df8f94b8f7c8c9bd47ce8ef7c489ac78c62cf7b6e9797f1086d0a4b6f60" => :high_sierra
    sha256 "2574e6b0ae4e5906b1cb546b23dc74b06c0c3494d477b8ce0c1d743d1515bfee" => :sierra
    sha256 "729c644b587941668f0412de6a1d7aafc078b375f96421b278daecba51469ed8" => :el_capitan
    sha256 "1576ba09d791c923265c5668aa0a0d5e7d806848d45e06210c0e3a5449bf1403" => :yosemite
    sha256 "394909ad355846b561077f89a216fc87902d116dfcb970b92ff7f563a3d5ce3e" => :mavericks
  end

  conflicts_with "john-jumbo", :because => "both install the same binaries"

  patch :DATA # Taken from MacPorts, tells john where to find runtime files

  def install
    ENV.deparallelize
    arch = MacOS.prefer_64_bit? ? "64" : "sse2"
    target = "macosx-x86-#{arch}"

    system "make", "-C", "src", "clean", "CC=#{ENV.cc}", target

    # Remove the README symlink and install the real file
    rm "README"
    prefix.install "doc/README"
    doc.install Dir["doc/*"]

    # Only symlink the binary into bin
    libexec.install Dir["run/*"]
    bin.install_symlink libexec/"john"

    # Source code defaults to 'john.ini', so rename
    mv libexec/"john.conf", libexec/"john.ini"
  end
end


__END__
--- a/src/params.h	2012-08-30 13:24:18.000000000 -0500
+++ b/src/params.h	2012-08-30 13:25:13.000000000 -0500
@@ -70,15 +70,15 @@
  * notes above.
  */
 #ifndef JOHN_SYSTEMWIDE
-#define JOHN_SYSTEMWIDE			0
+#define JOHN_SYSTEMWIDE			1
 #endif
 
 #if JOHN_SYSTEMWIDE
 #ifndef JOHN_SYSTEMWIDE_EXEC /* please refer to the notes above */
-#define JOHN_SYSTEMWIDE_EXEC		"/usr/libexec/john"
+#define JOHN_SYSTEMWIDE_EXEC		"HOMEBREW_PREFIX/share/john"
 #endif
 #ifndef JOHN_SYSTEMWIDE_HOME
-#define JOHN_SYSTEMWIDE_HOME		"/usr/share/john"
+#define JOHN_SYSTEMWIDE_HOME		"HOMEBREW_PREFIX/share/john"
 #endif
 #define JOHN_PRIVATE_HOME		"~/.john"
 #endif
