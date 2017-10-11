class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "http://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.0/logstalgia-1.1.0.tar.gz"
  sha256 "680d47babea2665a674032abed7a60cbecf00378b5b9924d265b1c063a7110c3"

  bottle do
    sha256 "64904c202bf0bec255b91739f8c7be3e42a1d63b8fe05b57b51f91f8023b9d3c" => :high_sierra
    sha256 "25fddba742b96d2b2f129ab2ca22daf395e0453d636c909f9d8ec470566bb121" => :sierra
    sha256 "a1bb4bbca7cc5faa4dd0ae9d84e660bdfa21207b26cb2f2dffa680c0584e0700" => :el_capitan
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
