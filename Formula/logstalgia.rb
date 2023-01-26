class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.4/logstalgia-1.1.4.tar.gz"
  sha256 "c049eff405e924035222edb26bcc6c7b5f00a08926abdb7b467e2449242790a9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "41dbb3eca9e29150230d903ba6aa7df60519beef66aba71ff43921b19c317151"
    sha256 arm64_monterey: "aaa66a9d512e36930484677b62cdfdda23533c30c4ad626c3bb2c7d0a52335b1"
    sha256 arm64_big_sur:  "b7074450d72aaf9260bf33bad971a3c1f7348b67334e2906353ea9e4a60ddf97"
    sha256 ventura:        "c358ed85782bd34b274f7cb00e0a854edff0465ce527034194258abba9b231ac"
    sha256 monterey:       "5cc41a5a64a33d430f53d62e384f2f6fa33a9bb19063d4df2e2d290e1b902159"
    sha256 big_sur:        "d04e3e79136ec4744c9d82ca7aef22972a5b428489313f2f3064aae8483ecf1d"
    sha256 x86_64_linux:   "e1e192bda5c6eb48dda5e4b91a40a2467ae9b80d214281bd328133ea70ebcb31"
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", *std_configure_args,
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
