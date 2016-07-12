class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/0.9.3/libbluray-0.9.3.tar.bz2"
  sha256 "a6366614ec45484b51fe94fcd1975b3b8716f90f038a33b24d59978de3863ce0"
  revision 2

  bottle do
    cellar :any
    sha256 "217f1bf948a08ef8a4de23ff23d569cd0545787f9e79133226d7a61573482a31" => :el_capitan
    sha256 "8efc8504d21a0dcc9ce18bc2bb39824b2ebe9dddf87bc4487933025c164e8ebf" => :yosemite
    sha256 "5fd5cbbe402b99cb817e6938f73a6d4a359e99b242eac8149aa5480f64e4a479" => :mavericks
  end

  head do
    url "https://git.videolan.org/git/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-ant", "Disable Support for BD Java"

  depends_on "pkg-config" => :build
  depends_on "freetype" => :recommended
  depends_on "fontconfig"
  depends_on "ant" => [:build, :optional]

  def install
    # https://mailman.videolan.org/pipermail/libbluray-devel/2014-April/001401.html
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    ENV.libxml2

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--without-freetype" if build.without? "freetype"
    args << "--disable-bdjava" if build.without? "ant"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
