class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.1.7.tar.gz"
  sha256 "1d99e3b309aa94d8f4fe7b4e953f038396ab46c1fc809ac06fffbe21ffcb64b3"

  bottle do
    cellar :any
    sha256 "f4f004d0e0cc2ac9b75eb713fa97d46b75ec4f307be2ffb967f8af6301286079" => :sierra
    sha256 "3cef9babea714c7a533dd5b3e8735268a774ffb2117e0b8040828bb3624c13a5" => :el_capitan
    sha256 "e5f08f29d81dcc7c14641de313ccf8c7f37c7ba1f3b5a77bc4643f42c694b07d" => :yosemite
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
