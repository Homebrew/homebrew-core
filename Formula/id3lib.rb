class Id3lib < Formula
  desc "ID3 tag manipulation"
  homepage "https://id3lib.sourceforge.io/"
  license "LGPL-2.0-or-later"
  revision 1
  head ":pserver:anonymous:@id3lib.cvs.sourceforge.net:/cvsroot/id3lib", using: :cvs, module: "id3lib-devel"

  stable do
    url "https://downloads.sourceforge.net/project/id3lib/id3lib/3.8.3/id3lib-3.8.3.tar.gz"
    sha256 "2749cc3c0cd7280b299518b1ddf5a5bcfe2d1100614519b68702230e26c7d079"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e223e971/id3lib/id3lib-vbr-overflow.patch"
      sha256 "0ec91c9d89d80f40983c04147211ced8b4a4d8a5be207fbe631f5eefbbd185c2"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e223e971/id3lib/id3lib-main.patch"
      sha256 "83c8d2fa54e8f88b682402b2a8730dcbcc8a7578681301a6c034fd53e1275463"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d7b4e26e6b79cdc70261532ee5f64546900499c9dbfdf66c0959ea3a30c8a3a8"
    sha256 cellar: :any,                 arm64_monterey: "bde33424b92f09c04a31be4efbb346254d6027b5bbc1bd290fd59dfd649b7e9a"
    sha256 cellar: :any,                 arm64_big_sur:  "7511c1df301e89112972d2b8aa0cc3711f4be7276317f345a26e64ae2a31143b"
    sha256 cellar: :any,                 ventura:        "0a4d41f11ad2eea0de2aa345508c35aab669de388368883e6fdab54ae845d12c"
    sha256 cellar: :any,                 monterey:       "a5dd0668b696e1d6c3ac17d1d516c2a41ea354606c9db893b90575d01f714a40"
    sha256 cellar: :any,                 big_sur:        "18f0b568466493ca322662357962fecfe1774844ad140be1c2d23443c2845ff3"
    sha256 cellar: :any,                 catalina:       "914ff24e2ca015f81b5c58fbd39f1a059c10ecbca87d09cf7e77285435bd158e"
    sha256 cellar: :any,                 mojave:         "fa00373e74d0b57967108dd48b652bf6750c742db31ab72ff9b7c8c777ba181e"
    sha256 cellar: :any,                 high_sierra:    "33c419dd2789c20e5e71b96185e41b2c81b2056d84b0e1a5cea0835e58dfb572"
    sha256 cellar: :any,                 sierra:         "1dddf1fac71acc4bd54cfcc6cdb80884129754d25f42efff5fbe6d5d38d99c0a"
    sha256 cellar: :any,                 el_capitan:     "266926f3fe3593bd04db9b9ff200676aaeb879d1f855e289cc41d2b40d72a16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5648fdcafc5fc4ea60431c568ff4856334be3a139e4d4d696257b58b1a6be09b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "zlib"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e223e971/id3lib/no-iomanip.h.patch"
    sha256 "da0bd9f3d17f1dd054720c17dfd15062eabdfc4d38126bb1b2ef5e8f39904925"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e223e971/id3lib/automake.patch"
    sha256 "c1ae2aa04baee7f92301cbed120340682e62e1f839bb61f8f6d3c459a7faf097"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e223e971/id3lib/boolcheck.patch"
    sha256 "a7881dc25665f284798934ba19092d1eb45ca515a34e5c473accd144aa1a215a"
  end

  # fixes Unicode display problem in easytag: see Homebrew/homebrew-x11#123
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e223e971/id3lib/patch_id3lib_3.8.3_UTF16_writing_bug.diff"
    sha256 "71c79002d9485965a3a93e87ecbd7fed8f89f64340433b7ccd263d21385ac969"
  end

  patch :DATA

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
--- a/include/id3/id3lib_strings.h
+++ b/include/id3/id3lib_strings.h
@@ -30,6 +30,7 @@
 #define _ID3LIB_STRINGS_H_

 #include <string>
+#include <cstring>

 #if (defined(__GNUC__) && (__GNUC__ >= 3) || (defined(_MSC_VER) && _MSC_VER > 1000))
 namespace std
--- a/include/id3/writers.h
+++ b/include/id3/writers.h
@@ -30,7 +30,7 @@

 #include "id3/writer.h"
 #include "id3/id3lib_streams.h"
-//#include <string.h>
+#include <cstring>

 class ID3_CPP_EXPORT ID3_OStreamWriter : public ID3_Writer
 {
