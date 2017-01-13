class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.1.5.tar.gz"
  sha256 "e1ba284bc23269f17b850d9f3ed5258719d1a62e35ec7cfc9d943bca11cb6563"

  bottle do
    cellar :any
    sha256 "bfbbbdb58bed35c90063db8ee3ec390261a7a24546fe1a82f44b0e07b7f5aaba" => :sierra
    sha256 "f78cce8785510271a83c90905cd952c996ea8da966ad075cd532902084b23f3a" => :el_capitan
    sha256 "98c9ff971ea4c2533db35ba9bcc2be05fd0f51bb874602cc9e5e79944a273172" => :yosemite
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
