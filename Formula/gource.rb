class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.52/gource-0.52.tar.gz"
  sha256 "92e713291936cc4688b6d3d52868f4cca4263c2efec9b3848086e93cd9935e08"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "1c73e63e38f78e848e9f3dbc4ee48c80eff0ca1c9c455bc871dbefa7ce9b05b1"
    sha256 arm64_big_sur:  "5391072ce69057a19ba0270f3a174bbcf6ea3b87eb8a27f9c3338e9ed96c6b55"
    sha256 monterey:       "e00886c4c8d3e3c024086da0811c629c4212a2bd28e3a43014a231a7d2980e68"
    sha256 big_sur:        "0b3f32ffa9b3e5277fb860059121dd35e57cab39c859cec20ffa687648a4b8bd"
    sha256 catalina:       "aca0d1acc8d793b57d1d9b1eaf0e23eff007168dfee847fd47ee5f6d741714a9"
    sha256 x86_64_linux:   "48c6dbf70ab1ad72876b5806ca745e62762d12d3f894d7ecd9f8f22bbd43316e"
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
