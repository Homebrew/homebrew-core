class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.1.4.tar.gz"
  sha256 "8d88aa8d1e197084a84994cc1caf2c3eff69e60ce4badc0addeb35d02ec57109"

  bottle do
    cellar :any
    sha256 "1d144465bb4233d3525e09350b470a590ab38d275e6476ae85aea63ddbdc9b90" => :sierra
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
