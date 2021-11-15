class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.51/gource-0.51.tar.gz"
  sha256 "19a3f888b1825aa7ed46f52cebce5012e3c62439e3d281102f21814c7a58e79a"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "f0cb70d2215129ed1ea427f9c8848b63791e05a27c62d76de601468ce7646b17"
    sha256 arm64_big_sur:  "82302ee7b3e01da62323d61a452fc81e5ec4fb62c2a04c8856e2f72373bf52cc"
    sha256 monterey:       "e90445fc5e02e071088ffd5e7da0fce6e5f73a3b85441a9f0f35770d8118ce2a"
    sha256 big_sur:        "bea0be45970ab69265303255911c279c2a739de3a8fd858e60ad18f1465cfc0f"
    sha256 catalina:       "544380bd35795b5a809d536b6458b9e4a0f8fc940f36f6f8e54255091aa98250"
    sha256 mojave:         "a603e1573f244abd8bc2a8963538ca6da27fbff90e68666e752678159c215baa"
    sha256 high_sierra:    "9e1ed79145083e62e52f6416b08d0d80c778cae6a8ba83808fb17f841cd6c136"
    sha256 x86_64_linux:   "65730cf451ae43ba3e105e3c7846914a65d82b4cd90699f146e15fda984de07e"
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
  depends_on "pcre"
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
