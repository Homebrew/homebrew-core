class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/0.9.3/libbluray-0.9.3.tar.bz2"
  sha256 "a6366614ec45484b51fe94fcd1975b3b8716f90f038a33b24d59978de3863ce0"
  revision 3

  bottle do
    cellar :any
    sha256 "9206252a034dc4263e0bb931d81d46e1c90d6d29a5b753bfc45a833a7169d804" => :sierra
    sha256 "105bd3fb170a3c90808a64ba850cd8ef51165c369e07518d5d159dbc50879940" => :el_capitan
    sha256 "831eb98859d81bc870b9eb13e6102b7eb731c5ade4f0ca477450710b7550f387" => :yosemite
    sha256 "b6c3b4530f4c38cf1e816e3a47acf5b26db50af2a016acde9a83b584450b26b0" => :mavericks
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
