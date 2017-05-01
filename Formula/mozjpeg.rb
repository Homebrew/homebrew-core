class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/releases/download/v3.2/mozjpeg-3.2-release-source.tar.gz"
  sha256 "8aecc1ecad447a73ae01b9a546e99142345e5a92838d84af425f2b19202e7b73"

  bottle do
    cellar :any
    sha256 "0ce5b3ad940976994bbfbf4539709712eaa2ce6b8b45f9ac2ce30a0d31e4e858" => :sierra
    sha256 "ad93e6e201c134282c5c637dfddf127670034d7c0d854ab3e980f8589aa29da2" => :el_capitan
    sha256 "3357079063037751fcd9698ee9980368ddbdb2bb3d9770d3767d3a76e6838148" => :yosemite
    sha256 "1d779644f67e48436476fd7a6849b63db2805da812f28e02ccec0219ade8f052" => :mavericks
  end

  head do
    url "https://github.com/mozilla/mozjpeg.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg."

  depends_on "pkg-config" => :build
  depends_on "nasm" => :build
  depends_on "libpng" => :optional

  def install
    system "autoreconf", "-fvi" if build.head?
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
