class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.4/logstalgia-1.1.4.tar.gz"
  sha256 "c049eff405e924035222edb26bcc6c7b5f00a08926abdb7b467e2449242790a9"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 arm64_sonoma:   "ebcc366bc89707b9162c908f9ca976c662e6fe4bbc0bcbd7c8ced4d481efacd4"
    sha256 arm64_ventura:  "af8ca708d5d4cc686dbc42ec2f5260be152d7823f3779e4e0c31f1c48be34085"
    sha256 arm64_monterey: "993e38fc86fdf9c5ba13fbaecb5f9bedfa2f49cb5587898b261a67d3e19b6650"
    sha256 sonoma:         "6fb15c1f5cc4a1a0a15d115f2fcf3b642f439f04a1cd465cac88e9d03f10f363"
    sha256 ventura:        "c60401be9305eeb994adaac41c4d96a9adbf1366fd315d29ed80507cee3976bf"
    sha256 monterey:       "7d4fa50e176d7c50f2935b9153adeb4cf2af2a3487ff195d9e5382659f7c3c0e"
    sha256 x86_64_linux:   "8f1966921df697fec54ec26fe73cc2ceba9a3e3801c651269134ed88aebb8c1a"
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
