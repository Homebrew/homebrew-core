class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.6.tar.xz"
  sha256 "408eb742b172a0ccbd128a0ff6402eee495839cd905198ce2b3f2607bba617f4"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libmspub[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "c57160bf9a45efcd4e5f47a521f80588d9b4daaa77956292c25758e5f01338a0"
    sha256 cellar: :any, arm64_golden_gate: "c3174720121f8245c480cbf4080dbe920d193475c782a2a4d39b3a739113e0b5"
    sha256 cellar: :any, arm64_tahoe:       "47dde38d071be4b4b72042259950a961724c6a40222d0d5785b23e67a3e7e15e"
    sha256 cellar: :any, arm64_sequoia:     "07afd3addc982da7d55bd3de982171df04c128397ef4bbd8d7b0917ac924af0b"
    sha256 cellar: :any, arm64_linux:       "f65052a5b96b8c5435a119596f36b00049c8c8701a9acf843d7802c42d5e9bed"
    sha256 cellar: :any, x86_64_linux:      "b4c87e6f83025c6da81b0556b454e4039391de29e0520f8b1093ba083797d09b"
  end

  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@79"
  depends_on "librevenge"
  depends_on "libwpd"

  on_linux do
    depends_on "zlib-ng-compat"

    # Fix for missing include needed to build with recent GCC. Remove in the next release.
    # Commit ref: https://git.libreoffice.org/libmspub/+/698bed839c9129fa7a90ca1b5a33bf777bc028d1%5E%21
    patch :DATA
  end

  deny_network_access!

  def install
    # icu4c 75+ needs C++17 and icu4c 76+ needs icu-uc
    # TODO: Fix upstream
    icu4c_lib = dep("icu4c").opt_lib
    ENV["ICU_LIBS"] = "-L#{icu4c_lib} -licui18n -licuuc"
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
                    "-I#{formula_opt_include("librevenge")}/librevenge-0.0",
                    "-lmspub-0.1", "-I#{include}/libmspub-0.1",
                    "-L#{lib}", "-L#{formula_opt_lib("librevenge")}"
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
 
