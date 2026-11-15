class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.5.tar.xz"
  sha256 "3671095f5a10bee8a755052a30576952c5b16d8b0f2ba9f2fb998338c18cb119"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libmspub[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2d2d887b00c5dc3eeefeae2e46d77bf8fe040965b702bc2d5defdbb0a7fb4999"
    sha256 cellar: :any, arm64_tahoe:       "9edbd5a611b9ed669cda39d9842df08944f786ccccba4155042850a024508df1"
    sha256 cellar: :any, arm64_sequoia:     "2c27502c0e1bbcceceddf64ed75d918c5478f8455ebb5fc77a1fe3e36c96df15"
    sha256 cellar: :any, arm64_linux:       "f781d3ab7663805e0040a89735dae80b07ab28f9bee7e92ebb6db9c626872820"
    sha256 cellar: :any, x86_64_linux:      "a45a555d1b3164fa73178bc062ff9a2e970936d47d363a554e61a92991911327"
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
 
