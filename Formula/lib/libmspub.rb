class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.4.tar.xz"
  sha256 "ef36c1a1aabb2ba3b0bedaaafe717bf4480be2ba8de6f3894be5fd3702b013ba"
  license "MPL-2.0"
  revision 16

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libmspub[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b33108e9f470c326457ce72597150776142fe65cef4e836ab316e1aa53efe419"
    sha256 cellar: :any,                 arm64_sonoma:  "bd81708ab36ccd98ab4d0ae5b9c05358161168e1736270abf53ebfa3d4dd3bc5"
    sha256 cellar: :any,                 arm64_ventura: "4f8fbeaa5611e8a8fdbd043689f5919e559364b2306dc030f937d40ef6d17110"
    sha256 cellar: :any,                 sonoma:        "7b3a6c9a3272ca1ae667c95d708f1b9d2a61de80ee77d8767184e0be4ef05ddf"
    sha256 cellar: :any,                 ventura:       "cebfac88c71d5c974b27d87383c8ea1226827688245697dcf794f481bd3a34bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6392ab88071ddb41424b8ddb0698e9c45a0a89ae91bcb801938e00c46b155613"
  end

  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c@75"
  depends_on "librevenge"
  depends_on "libwpd"

  # Fix for missing include needed to build with recent GCC. Remove in the next release.
  # Commit ref: https://git.libreoffice.org/libmspub/+/698bed839c9129fa7a90ca1b5a33bf777bc028d1%5E%21
  on_linux do
    patch :DATA
  end

  def install
    # icu4c 75+ needs C++17
    ENV.append "CXXFLAGS", "-std=gnu++17"

    system "./configure", "--disable-silent-rules",
                          "--disable-static",
                          "--disable-tests",
                          "--disable-werror",
                          "--without-docs",
                          *std_configure_args
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
 
