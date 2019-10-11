class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v3.3.1.tar.gz"
  sha256 "aebbea60ea038a84a2d1ed3de38fdbca34027e2e54ee2b7d08a97578be72599d"
  revision 1

  bottle do
    cellar :any
    sha256 "ef7d5b06f03e05a4babab7b464bb83475a9a3fedbaa78e1ceedf23f051828e4c" => :catalina
    sha256 "8f84ae70b36cba861c17bc0b7f3befa2e3d30fc807cadd70ed7af0521de325cb" => :mojave
    sha256 "36faaf1c7c6baaeaed402dc9239b594222e8bce4c8b7b8468d13e7d084c06582" => :high_sierra
    sha256 "1108870dce024757e600488eb3122994675ca81b4ed20fefd32a622d3ff6a2e8" => :sierra
  end

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-jpeg8"
    system "make", "install"
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose", "-optimize",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
  end
end
