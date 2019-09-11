class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/v4.2.0.tar.gz"
  sha256 "9523e38da6ee8b2a8f5ce83ded64107dd1e514c7ad00cd74ccfe3454b679c271"

  bottle do
    cellar :any
    sha256 "e43618d83730577d3a647565e919d8b8db6ccd6d947995b001fc75a6e02655f0" => :mojave
    sha256 "c39515311e41413a6a569dd3b652cac35c15fe21a51140976e7f3294b14193b7" => :high_sierra
    sha256 "bfe2db4593b4da91a11ccb7e73e4626a68f5d27463cc8db4149e0da7e42372f8" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1" if MacOS.version <= :sierra

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-examples",
                          "--disable-manpages"
    system "make"
    system "make", "install"
  end
end
