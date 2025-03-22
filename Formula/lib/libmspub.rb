class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.4.tar.xz"
  sha256 "ef36c1a1aabb2ba3b0bedaaafe717bf4480be2ba8de6f3894be5fd3702b013ba"
  license "MPL-2.0"
  revision 18

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libmspub[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1847309881161a713cb9c37bec7a23c452cdc44bf87c28c016f449c101b57b84"
    sha256 cellar: :any,                 arm64_sonoma:  "249d78a5299e65bd9ef5df4ea21d70aae17f40c3f075f34e04923b3880fb0257"
    sha256 cellar: :any,                 arm64_ventura: "fca947dbb384a02a7384989d0f5aa87e74d51460ef01e90555414d3b6b221473"
    sha256 cellar: :any,                 sonoma:        "363ef78cf1ad4658325059fb88d5ffbd1ff9dfb755a46480d7bf355dad00a07c"
    sha256 cellar: :any,                 ventura:       "3ff4c780cd0546ea13e77aeffa63b9b8b5e31dd6a12c1b34bcc9275239942965"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87665795cf7ed3a80d5798d80760aa4780ee5658512ee0563802951cb9057c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "256986816dfba4c397abe672d087ed464766aff3aaad05f80c4a99672fb155d4"
  end

  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
  depends_on "librevenge"
  depends_on "libwpd"

  uses_from_macos "zlib"

  # Fix for missing include needed to build with recent GCC. Remove in the next release.
  # Commit ref: https://git.libreoffice.org/libmspub/+/698bed839c9129fa7a90ca1b5a33bf777bc028d1%5E%21
  on_linux do
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
 
