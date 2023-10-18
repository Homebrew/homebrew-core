class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.4.tar.xz"
  sha256 "ef36c1a1aabb2ba3b0bedaaafe717bf4480be2ba8de6f3894be5fd3702b013ba"
  license "MPL-2.0"
  revision 14

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libmspub[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd2bb38bdffffa662ebebce65306c5d4944eaab0a8278385d54d37de0a5b15cf"
    sha256 cellar: :any,                 arm64_ventura:  "f53ba0f603ff82e1be6edf58ea68ddc5cf15618ecc9425bf7d25686600ffaa6e"
    sha256 cellar: :any,                 arm64_monterey: "d3f278ac26e5f228b769821daf271faf2ad535eddace9459cc0931daabd2adff"
    sha256 cellar: :any,                 arm64_big_sur:  "7eb5fddbb726a0d7f26fe9617651d47cf4ac9808c3210dcc42379841a618a5a5"
    sha256 cellar: :any,                 sonoma:         "cf2dbb53b96683355b136ddbbcadb093cfd14bd9da35dab1d8611d45ad205dd5"
    sha256 cellar: :any,                 ventura:        "3e127402489dc095a2b0716a21ac188f22c4cfc7bcd1a19724a123cc0bd1559b"
    sha256 cellar: :any,                 monterey:       "f5f6346fb4dae4e768dec30a28a8cefd01b45e3d029b3074dca1f5022f28136f"
    sha256 cellar: :any,                 big_sur:        "9245461f9a2f04aa3216a72fa1d2de594bf4a979b83a90d0b88fa72658b67647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c6660cd4a5cd1b0ab0040ae7a22251ebac88ac84d6d38a3631e47b5f21d8254"
  end

  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "libwpd"

  # Fix for missing include needed to build with recent GCC. Remove in the next release.
  # Commit ref: https://git.libreoffice.org/libmspub/+/698bed839c9129fa7a90ca1b5a33bf777bc028d1%5E%21
  on_linux do
    patch :DATA
  end

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <librevenge-stream/librevenge-stream.h>
      #include <libmspub/MSPUBDocument.h>
      int main() {
          librevenge::RVNGStringStream docStream(0, 0);
          libmspub::MSPUBDocument::isSupported(&docStream);
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-lmspub-0.1", "-I#{include}/libmspub-0.1",
                    "-L#{lib}", "-L#{Formula["librevenge"].lib}"
    system "./test"
  end
end

__END__
From 698bed839c9129fa7a90ca1b5a33bf777bc028d1 Mon Sep 17 00:00:00 2001
From: Stephan Bergmann <sbergman@redhat.com>
Date: Tue, 11 Jun 2019 12:15:28 +0200
Subject: [PATCH] missing include

Change-Id: I3c5c085f55223688cdc7b972f7c7981411881263
Reviewed-on: https://gerrit.libreoffice.org/73814
Reviewed-by: Michael Stahl <Michael.Stahl@cib.de>
Tested-by: Michael Stahl <Michael.Stahl@cib.de>
---

diff --git a/src/lib/MSPUBMetaData.h b/src/lib/MSPUBMetaData.h
index 9167f4f..27bdd4f 100644
--- a/src/lib/MSPUBMetaData.h
+++ b/src/lib/MSPUBMetaData.h
@@ -13,6 +13,7 @@
 #include <map>
 #include <utility>
 #include <vector>
+#include <stdint.h>
 
 #include <librevenge/librevenge.h>
 
