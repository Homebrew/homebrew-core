class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "http://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.0/logstalgia-1.1.0.tar.gz"
  sha256 "680d47babea2665a674032abed7a60cbecf00378b5b9924d265b1c063a7110c3"

  bottle do
    sha256 "a71a48c25d569e05cb05501f205761e7172ca2bbf5629e73c54248c44ee99685" => :high_sierra
    sha256 "21df0eed9f44a7f181ddbe290253cafe3686f906720ec67ca269ba7306d51071" => :sierra
    sha256 "631cd193fcc281640cfe7ac40de59d1227ac099414889a0d42ae51b3e63d35cd" => :el_capitan
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre"

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
