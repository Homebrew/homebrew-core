class Id3lib < Formula
  desc "ID3 tag manipulation"
  homepage "https://id3lib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/id3lib/id3lib/3.8.3/id3lib-3.8.3.tar.gz"
  sha256 "2749cc3c0cd7280b299518b1ddf5a5bcfe2d1100614519b68702230e26c7d079"
  license "LGPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c32250cc13c45be4e25507819ad3fb788b3031ad781d97b61bb721c95e6001f3"
    sha256 cellar: :any,                 arm64_sequoia: "dd2afb2b4e882de0fbdc279c2a993064a6b07527f0dd67298ffa568d1b445dca"
    sha256 cellar: :any,                 arm64_sonoma:  "53c2b06123a0c4b17047798d199891a38be8808265bc5e3d265e2aa3e58d942c"
    sha256 cellar: :any,                 sonoma:        "9cdc748bec10b52b864e3201a1ab0d1660fb92827b1587610e008b85a272b495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2fc13b429cf5142874639c62498f0311474c8d09ff3aaed76843704359d82d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b2b224334a73c8dd5e56bf5b8ff37d5e82fd02a700a62c13bc149ad5f8493f6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/id3lib/id3lib-main.patch"
    sha256 "83c8d2fa54e8f88b682402b2a8730dcbcc8a7578681301a6c034fd53e1275463"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/id3lib/id3lib-vbr-overflow.patch"
    sha256 "0ec91c9d89d80f40983c04147211ced8b4a4d8a5be207fbe631f5eefbbd185c2"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/id3lib/no-iomanip.h.patch"
    sha256 "da0bd9f3d17f1dd054720c17dfd15062eabdfc4d38126bb1b2ef5e8f39904925"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/id3lib/automake.patch"
    sha256 "c1ae2aa04baee7f92301cbed120340682e62e1f839bb61f8f6d3c459a7faf097"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/id3lib/boolcheck.patch"
    sha256 "a7881dc25665f284798934ba19092d1eb45ca515a34e5c473accd144aa1a215a"
  end

  # fixes Unicode display problem in easytag: see Homebrew/homebrew-x11#123
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/id3lib/patch_id3lib_3.8.3_UTF16_writing_bug.diff"
    sha256 "71c79002d9485965a3a93e87ecbd7fed8f89f64340433b7ccd263d21385ac969"
  end

  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
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
