class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://gource.io/"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.55/gource-0.55.tar.gz"
  sha256 "c8239212d28b07508d9e477619976802681628fc25eb3e04f6671177013c0142"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 arm64_sequoia: "eaf4ff31b1f3bc0ad7780621d818a52c122457a0acd3f8cc7981a4e991ed5d00"
    sha256 arm64_sonoma:  "3ac079184927b61caed9d6e730d7a92befa629fa1859a22119bea34226889de5"
    sha256 arm64_ventura: "cf121b18f4ee35b87f92285ca3670fd175116db4332ef8755c2a5429e87325c3"
    sha256 sonoma:        "a0f0c65db5150647935f565bb7b3be7db2dfaec75876ba8d957dc6f863f5df7e"
    sha256 ventura:       "2a3cae9515ebd8ae804a0eceba561204b12b2c6073bf9e9240ddacb14a135cd2"
    sha256 arm64_linux:   "6c3f0d8672cc9b85f4384f096b9dc910eb44ce072a34eac2e7fa1fb8ef67ed43"
    sha256 x86_64_linux:  "a4ac1d4979d98597dc5bdcf79947891ddeefa6ad589bd35584fdb8a050eb6c18"
  end

  head do
    url "https://github.com/acaudwell/Gource.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    ENV.cxx11

    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gource", "--help"
  end
end
