class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.53/gource-0.53.tar.gz"
  sha256 "3d5f64c1c6812f644c320cbc9a9858df97bc6036fc1e5f603ca46b15b8dd7237"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "8c9e86ad45ba8630cd05e383bbbdb5b1f101738503939c3a0ef6934ed53c2abb"
    sha256 arm64_big_sur:  "e1a1a92ec314a0148a65a40da7700e420d7e3a551697df0dd7a5e3b268aef8a4"
    sha256 monterey:       "20a36d2b4a71e831b0a56ea2f0e9ecd9b63522049c94cdac919c0fd6cebf3525"
    sha256 big_sur:        "6b5e4b998e41e5d9a324558f7f9dc7e1628427c6a7200873ef41dff4b19dc801"
    sha256 catalina:       "126d8527077616ecd853d1658ff0588884e30c0c2fab4b19acded5847e41f8ed"
    sha256 x86_64_linux:   "dd1ba91a71c855b13afa89730f438085c46cf2b17e1bf9e137f83fda0505d79d"
  end

  head do
    url "https://github.com/acaudwell/Gource.git"

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
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    system "#{bin}/gource", "--help"
  end
end
