class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "http://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.0.7/logstalgia-1.0.7.tar.gz"
  sha256 "5553fd03fb7be564538fe56e871eac6e3caf56f40e8abc4602d2553964f8f0e1"
  revision 1

  bottle do
    sha256 "4fae5eeb1bb14c971dd617336aa9212d1805b3093e7b0a7cb44f92e7fe1ef09c" => :sierra
    sha256 "ff663d84629d8d26a43498394ff9ea8231d79e60c836e2f7862685a7ee3f6592" => :el_capitan
    sha256 "d224adca8bdd80d7145b23be1a70e201fe49139b47eea9a713d18cfb38c52c61" => :yosemite
    sha256 "7527bbe6dc03b41d5dad76d4a60fe698c54baa9453b089d821985b3c048e487f" => :mavericks
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
  depends_on "jpeg"
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
