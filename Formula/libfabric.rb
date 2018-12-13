class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.6.2/libfabric-1.6.2.tar.bz2"
  sha256 "ec63f61f5e529964ef65fd101627d8782c0efc2b88b3d5fc7f0bfd2c1e95ab2c"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 "011527580e0bb34a0c374704b245406619ffbad08bbaf24d871c35a7574f9094" => :mojave
    sha256 "7cf9f040235c4a97f2d1b5e1018ed16fc061c0eb139e0ac0fa6d4b24d4ad3ceb" => :high_sierra
    sha256 "68bb847a11e31c2798118dbd096046e29bbb5ee76051a4b1988b01656dd9b836" => :sierra
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
