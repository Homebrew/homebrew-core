class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.1.3.tar.gz"
  sha256 "e34cf60cffc80aa1322d2c3a9b81e662c2576d2b03e53ddf1079615634e6f553"

  bottle do
    cellar :any
    sha256 "f7d3a3d4d2b28826af6685794976b58fea07f5160b008edd17c42935ee03dfce" => :el_capitan
    sha256 "ae9f15f1c7169b5c7bee052f7f5c29c577f18e590ca3d8313b1a8808ad5ac3b9" => :yosemite
    sha256 "00c7c45ad063788a6bd384dcdb8e71f617e8b7d9ee2eddc65a031319bd7b5ad2" => :mavericks
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
