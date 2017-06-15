class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/1.0.1/libbluray-1.0.1.tar.bz2"
  sha256 "0f9f9a1db2f48cafc70ed2596ff3594b597e2027408f5f2be6191c245d67853a"

  bottle do
    cellar :any
    sha256 "11ebf8f77e5562b5eed56947c226ad6296c19ff1b0673c0c6193d371bcb3b662" => :sierra
    sha256 "4c77115e125da37a65fc2e25dc5c81fc3570a929ad326260ebf34c6766ce14ef" => :el_capitan
    sha256 "9fc846e7a84e60a6a19c5efc3f9e8cc433cc980761b232e4f99775afa3769b8a" => :yosemite
  end

  head do
    url "https://git.videolan.org/git/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "ant" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype" => :recommended

  def install
    # https://mailman.videolan.org/pipermail/libbluray-devel/2014-April/001401.html
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--without-freetype" if build.without? "freetype"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
