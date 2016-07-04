class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/0.9.3/libbluray-0.9.3.tar.bz2"
  sha256 "a6366614ec45484b51fe94fcd1975b3b8716f90f038a33b24d59978de3863ce0"

  bottle do
    cellar :any
    sha256 "0fa19cffcf20ac8429ceef23dc556686b8220e99890397314a3be5836f544223" => :el_capitan
    sha256 "43cb563bff2c4f5b7d399bfc47c379493d623150b3e7318964e73e554954e6f3" => :yosemite
    sha256 "0c49dd693af0df53d428d6d8707e5164f329f76de8f18250a11c85ef7fa05be4" => :mavericks
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
