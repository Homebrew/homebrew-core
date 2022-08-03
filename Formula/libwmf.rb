class Libwmf < Formula
  desc "Library for converting WMF (Window Metafile Format) files"
  homepage "https://wvware.sourceforge.io/libwmf.html"
  url "https://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz"
  sha256 "5b345c69220545d003ad52bfd035d5d6f4f075e65204114a9e875e84895a7cf8"
  license "LGPL-2.1-only" # http://wvware.sourceforge.net/libwmf.html#download
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/libwmf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "5138927a0d8d528ab1a4f4929c1131c7c6e15995c22410ba722a8581b933de11"
    sha256 arm64_big_sur:  "2f03f6ad89f67e27361b64a23ab0e231e09c3ef0e6be5c6456bbaa4cadc38f91"
    sha256 monterey:       "c654530d1c940888ac542442827063f85850e18386008a4dedf1ca3711b80ca1"
    sha256 big_sur:        "aece69a239468a68f86c84ed6eff00120c821aec6b8f69674776f3e6a46b7c6e"
    sha256 catalina:       "9adf1c5052c7c0036c13a501f4f720fc7e8e511fcc8012ad8c8bfa3dcc457c94"
    sha256 x86_64_linux:   "06c5049479f0c63291c8f7c8ed6f73a5f3cc4acf6e9a495aeb8635eeecc72642"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gd"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "./configure", *std_configure_args,
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}",
                          "--with-jpeg=#{Formula["jpeg-turbo"].opt_prefix}"
    system "make"
    ENV.deparallelize # yet another rubbish Makefile
    system "make", "install"
  end
end
