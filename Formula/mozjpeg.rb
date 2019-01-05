class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v3.3.1.tar.gz"
  sha256 "aebbea60ea038a84a2d1ed3de38fdbca34027e2e54ee2b7d08a97578be72599d"
  revision 1

  bottle do
    cellar :any
    sha256 "c7038cd6e6db8b66641f95d7a86611b725d8c499019319fbbb27d34cc19b344e" => :mojave
    sha256 "1de665bbe8376b200128a2b9559694bbe1798407b5b095f9b3071cf837ff8176" => :high_sierra
    sha256 "e498ac87277b31d0a160ca13d38ba2a28ce96290fe8cde611e5e3fc08ea51a8f" => :sierra
    sha256 "755a475a3fd6b2ab8820456f292419907386a9a136cdc51e6b66e5200757735a" => :el_capitan
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
