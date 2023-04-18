class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.54/gource-0.54.tar.gz"
  sha256 "1dcbcedf65d2cf4d69fe0b633e54c202926c08b829bcad0b73eaf9e29cd6fae5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "b49d8188e5f03e8a549e24c1329b1dbffe05032a42d2766419c84d385647d1b6"
    sha256 arm64_monterey: "5cbf7ad844d7f4b7ea5d35dda94ef8c7ee08ce22cf9b3806ecee0898beb37169"
    sha256 arm64_big_sur:  "746a24a730d8bd1e158285c6ba4669720940037fd8cfce3454ed2e25bbc396b6"
    sha256 ventura:        "e10bfbc4f393a035672da37fcb8e47027b55aea4f4e755aa9ac681954178e0c6"
    sha256 monterey:       "a6f62398a07576b5cf518f4874a93a1d537bf835957c6da7d2627f3914684bd4"
    sha256 big_sur:        "92bdb6e29436032811b16bdf9889bebf5e72c092958756e641eef6ea63e5f0d3"
    sha256 x86_64_linux:   "aa829a21babf52ff635254d908b3beee9447d3f05a07b144c1cfb3b84abfd0ce"
  end

  head do
    url "https://github.com/acaudwell/Gource.git", branch: "master"

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
