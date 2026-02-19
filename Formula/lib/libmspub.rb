class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.4.tar.xz"
  sha256 "ef36c1a1aabb2ba3b0bedaaafe717bf4480be2ba8de6f3894be5fd3702b013ba"
  license "MPL-2.0"
  revision 19

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libmspub[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5cecb8db1dca13e86f7b8a41e9270f34e37485235327f3cca023975fb2ce630c"
    sha256 cellar: :any,                 arm64_sequoia: "4d212ebced14322c8c144697985552a703826c17d511d168b9ffc780ece1d421"
    sha256 cellar: :any,                 arm64_sonoma:  "164c06f73c3cba7a6c97282455db62a070f69a2dccb0ccf694788e8e452a155f"
    sha256 cellar: :any,                 sonoma:        "dc435295289043990c51abaca7c3030409065cd293202dcb0e4d38a426e3dc04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b15fe31563699e7f8021c51965fcd4785e18399a29a933465f68fc1f73d35b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdc0c07625d05b05a48378cda67ba1d66ea6e549c2489b386d104594381a5f5e"
  end

  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  depends_on "librevenge"
  depends_on "libwpd"

  on_linux do
    depends_on "zlib-ng-compat"

    # Fix for missing include needed to build with recent GCC. Remove in the next release.
    # Commit ref: https://git.libreoffice.org/libmspub/+/698bed839c9129fa7a90ca1b5a33bf777bc028d1%5E%21
    patch :DATA
  end

  def install
    # icu4c 75+ needs C++17 and icu4c 76+ needs icu-uc
    # TODO: Fix upstream
    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    ENV["ICU_LIBS"] = "-L#{icu4c.opt_lib} -licui18n -licuuc"
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
    (testpath/"test.cpp").write <<~CPP
      #include <librevenge-stream/librevenge-stream.h>
      #include <libmspub/MSPUBDocument.h>
      int main() {
          librevenge::RVNGStringStream docStream(0, 0);
          libmspub::MSPUBDocument::isSupported(&docStream);
          return 0;
      }
    CPP
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
 
