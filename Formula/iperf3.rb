class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.1.5.tar.gz"
  sha256 "e1ba284bc23269f17b850d9f3ed5258719d1a62e35ec7cfc9d943bca11cb6563"

  bottle do
    cellar :any
    sha256 "bc3ff59d7f3a7216c0c6ece46cd0772b8d6170032163052dc0e84e5b97cf281e" => :sierra
    sha256 "997c77ca9f70810a9361646bf8112b4122072a6318deadb303506a6a1323c92b" => :el_capitan
    sha256 "52e83458f2d880d6e4eafc1a7007c3a8a448e0104247b3666ec58405dee55d0e" => :yosemite
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    system bin/"iperf3", "--version"
  end
end
