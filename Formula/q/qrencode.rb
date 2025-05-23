class Qrencode < Formula
  desc "QR Code generation"
  homepage "https://fukuchi.org/works/qrencode/index.html.en"
  url "https://github.com/fukuchi/libqrencode/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "5385bc1b8c2f20f3b91d258bf8ccc8cf62023935df2d2676b5b67049f31a049c"
  license "LGPL-2.1-or-later"
  head "https://github.com/fukuchi/libqrencode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cecf1e7ce43e8748061ac53002415715527fa1f3edb8ae27d0cb406c988a2185"
    sha256 cellar: :any,                 arm64_sonoma:   "3226384aaa7dfe12685ac35c627a0bf3878c98e119e7057d8f86a6b8360fc65b"
    sha256 cellar: :any,                 arm64_ventura:  "c3065a87ad978bc0c2b3ff5a60371ad8f0d6f1f29d0584ac070e6cd998469561"
    sha256 cellar: :any,                 arm64_monterey: "6fa3a670e9708cf84470f82fd966e5610d0ad9d8c96c1f5987645b4db3fa65cb"
    sha256 cellar: :any,                 arm64_big_sur:  "aba117089d1c60fd2fa1d36fbfa06a0929b23d5bb6a7417d6f2dafb5dcc32c5b"
    sha256 cellar: :any,                 sonoma:         "3d7be7074b40470b1b4a883642d6a9d6b4d87794c1914c5d4134154b745b5084"
    sha256 cellar: :any,                 ventura:        "882d866b0ce145f3eef1b497ad8ffeae5d415984b28bcf77dd684d6dab789bb7"
    sha256 cellar: :any,                 monterey:       "ebc1b405866a1c2736d1fc49d268e35d08faf6a676f3151b160e1414b0edadc2"
    sha256 cellar: :any,                 big_sur:        "1b3d2022412f9d5486550fb68250aee25bb358a04e2cccc7bb85c7d65b1885b0"
    sha256 cellar: :any,                 catalina:       "326d2f182c7c8d9188be7adda5bd0ecb5922269f60f72ac265e404fa17fb310f"
    sha256 cellar: :any,                 mojave:         "a8ec712f32c4d8b09d4c098c37264ea41f0f382525c5b67e657248fdd9f1f53d"
    sha256 cellar: :any,                 high_sierra:    "a6d123b7f88941fe9959970d8b6ccfbc426c2ec405cfc731bc259f2b0f536171"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4f31dee099618d8ba49fd5219663bee1adcc8efbc4a42e0bd9bd9a81bcc76b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97aa13d3b6314c8a5d03edffa65c43f2f63b894a91a350de52a45367fe8f862f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libpng"

  # Addresses `qrencode.c:932:9: error: use of undeclared identifier 'VERSION'`
  # error when building.
  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"qrencode", "123456789", "-o", "test.png"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index c4ef27ab388f032e5d30578530d438e9669be643..0aae247bbf35ff5f187b15b751b5130107522e60 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,12 +4,15 @@ m4_define([__MICRO_VERSION], [1])dnl
 m4_define([__VERSION], [__MAJOR_VERSION.__MINOR_VERSION.__MICRO_VERSION])dnl
 AC_INIT(QRencode, __VERSION)
 
+VERSION=__VERSION
 MAJOR_VERSION=__MAJOR_VERSION
 MINOR_VERSION=__MINOR_VERSION
 MICRO_VERSION=__MICRO_VERSION
+AC_SUBST(VERSION)
 AC_SUBST(MAJOR_VERSION)
 AC_SUBST(MINOR_VERSION)
 AC_SUBST(MICRO_VERSION)
+AC_DEFINE_UNQUOTED([VERSION], [$VERSION], [Version number])
 AC_DEFINE_UNQUOTED([MAJOR_VERSION], [$MAJOR_VERSION], [Major version number])
 AC_DEFINE_UNQUOTED([MINOR_VERSION], [$MINOR_VERSION], [Minor version number])
 AC_DEFINE_UNQUOTED([MICRO_VERSION], [$MICRO_VERSION], [Micro version number])
