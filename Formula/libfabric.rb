class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.6.2/libfabric-1.6.2.tar.bz2"
  sha256 "ec63f61f5e529964ef65fd101627d8782c0efc2b88b3d5fc7f0bfd2c1e95ab2c"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 "caee1cc37d5a75002650185db9755ca2cdef2a4bb1112d655f687d915903723f" => :mojave
    sha256 "d54bc8c558cdb8cc043321e7d7525f5a6f0690941fb41dfb12911450eaa53721" => :high_sierra
    sha256 "affceee11460839d1688128378c8271ce1f0864a7622145bea792aa2d3acfc77" => :sierra
    sha256 "3586c060d04eaa55fa5a4f802ac4478cd762e1b303fe96c5bf22d8bbaba8f448" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
