class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/0.9.3/libbluray-0.9.3.tar.bz2"
  sha256 "a6366614ec45484b51fe94fcd1975b3b8716f90f038a33b24d59978de3863ce0"
  revision 2

  bottle do
    cellar :any
    sha256 "5b5fc234f491c10cbc6cb71897d3ad4b2ac508707839875afe007f44954edafe" => :el_capitan
    sha256 "9195b6a924f16521708dd7c3252c9027ea085d2aecd203158826739694bf2ef2" => :yosemite
    sha256 "ecd6c56c71390a90e3b9275661aa5e545af872056ee615f3ae518dd6a0913fbb" => :mavericks
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
