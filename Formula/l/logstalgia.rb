class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.4/logstalgia-1.1.4.tar.gz"
  sha256 "c049eff405e924035222edb26bcc6c7b5f00a08926abdb7b467e2449242790a9"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "03cd4bf0c812e179ab85cbe74a7e20bcbf32060a07fe556cae40ee6f50d140b1"
    sha256 arm64_ventura:  "9b001377cd185e70644b8428ce26297a7c4ae96112a54823bb081904ea879c5d"
    sha256 arm64_monterey: "c9f234fcec4d06c0e9c65d26071f4408baa98f3faaf27e39782464d020cba296"
    sha256 arm64_big_sur:  "2daf20ebefabb9a3e4574e1669ac4e4d07e2cc94175c3c2d0344f608f4d640a2"
    sha256 sonoma:         "4f59eb197c72ce63469fe355a9e3fc7a9b8c750efd9eb7f2f2335bb9b69ba446"
    sha256 ventura:        "d974776b03bfaf4523e459f9e4e9441cf29eef373930f770e574a84c17e70911"
    sha256 monterey:       "40d4ae599af8f864d33af1043f10fa51a61fd56be16cbb15dec46d9b0927741a"
    sha256 big_sur:        "87e55b99f349681141a8f23263d83e233b69f75b75eb9e8288ce767955fd80e0"
    sha256 x86_64_linux:   "817b2d9dff6267ecc43d36d3e5b300586d958073f77d6bb7c827c21fca184c6b"
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
