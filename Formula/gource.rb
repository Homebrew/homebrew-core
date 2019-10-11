class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.49/gource-0.49.tar.gz"
  sha256 "a9dd23693861e224322708a8e26c9e3aaa3e4c9ec41264b1ee2d5dcd6e2c0e8a"

  bottle do
    rebuild 1
    sha256 "6af5b890ecc507e13ac6720fb00d5e1bae3f1c4203cdcfa24ad9c96975a4b1e5" => :catalina
    sha256 "f7b1c895b7c202aae26d1396b2634082ede889eb5c9bf0b2d7758e52f88c924e" => :mojave
    sha256 "72e08ff92d3ac208ec5fcb9a6514ca0d47db160eb9cab604a236ea3a31a149de" => :high_sierra
    sha256 "de278ad81dfaa50d78f66b307044464b3db7741f02b5933ea1046347775674b8" => :sierra
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
