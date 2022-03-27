class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  license "GPL-3.0-or-later"
  revision 2

  stable do
    url "https://github.com/acaudwell/Gource/releases/download/gource-0.51/gource-0.51.tar.gz"
    sha256 "19a3f888b1825aa7ed46f52cebce5012e3c62439e3d281102f21814c7a58e79a"
    depends_on "pcre"
  end

  bottle do
    sha256 arm64_monterey: "e6a90d692a0d3efefc8374dc9076a01ebbdbf0dd29a7c124c8094c147f1ec2da"
    sha256 arm64_big_sur:  "e91fe4158f1f2d408a5fec4fb590033497e1bb337af2db4e143b83cce8487218"
    sha256 monterey:       "bdb1c66ffef09575d229ae40d192226fcf983e61c52a0d3484dde371769dc041"
    sha256 big_sur:        "ca110afcf913de409d69de047d555b65f46046c8c83211060f42f47792d74af2"
    sha256 catalina:       "00a73c5c8191582247ba81873e010a5a3998ce6f64abc4fcfc5e0214057af530"
    sha256 x86_64_linux:   "48e72a92a4d9a76c5a066d4f2ac03599649d32331a1a8f9a671b83e891e26e32"
  end

  head do
    url "https://github.com/acaudwell/Gource.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pcre2"
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
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
