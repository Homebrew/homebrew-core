class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.55/gource-0.55.tar.gz"
  sha256 "c8239212d28b07508d9e477619976802681628fc25eb3e04f6671177013c0142"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_sequoia:  "c735cd51d9e849ddae9f6fe7fee81279a997eed45faee857806e0f3fc0f7d560"
    sha256 arm64_sonoma:   "0e04c59ea31bcac42b276ddb55c793c3965c7c95863ee93980321a20768ba82b"
    sha256 arm64_ventura:  "f0c75e3218b79997ea769dc36701f78cd9c3471184f984b60ffb5d0dbec86268"
    sha256 arm64_monterey: "bd2bad94832bbc7e1a668c70b97dd7a2c432a43cdf316d753c29c5c739c04319"
    sha256 sonoma:         "e5b2f41f0a965a3dd857ff701ba535b85fe08719e395b1ddcb4aea54f81f3d63"
    sha256 ventura:        "99b2e09613f40fe201663c5e72d2688214358dc97373cfce90d8f73232eb61d5"
    sha256 monterey:       "bcbe2dbfcb48406b6f28a3579dc45a9c8a1c0c60cc8a6563301e1b52c2c9d73a"
    sha256 x86_64_linux:   "164916b7277e4beb805bd690735a859475dcd5d83690f5daff348eebb62d0374"
  end

  head do
    url "https://github.com/acaudwell/Gource.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    ENV.cxx11

    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gource", "--help"
  end
end
