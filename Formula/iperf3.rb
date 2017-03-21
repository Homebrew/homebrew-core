class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.1.7.tar.gz"
  sha256 "1d99e3b309aa94d8f4fe7b4e953f038396ab46c1fc809ac06fffbe21ffcb64b3"

  bottle do
    cellar :any
    sha256 "c9079d8bfc45c3cb16433950dafcd206aac5c0f57bc48cb13ad9bce0faed5b15" => :sierra
    sha256 "efb27f6d1f2e45e1c5d6e2d34040bb7a8d11718efe5e85b8415cf5998eeeb3b5" => :el_capitan
    sha256 "83c5fe7413994904f7fdc8c5fad5742ca7e259f0cc22f60a72bd134385bda645" => :yosemite
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
