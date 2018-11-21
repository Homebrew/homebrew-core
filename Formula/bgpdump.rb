class Bgpdump < Formula
  desc "C library for analyzing MRT/Zebra/Quagga dump files"
  homepage "https://bitbucket.org/ripencc/bgpdump/wiki/Home"
  url "https://bitbucket.org/ripencc/bgpdump/get/1.6.0.tar.gz"
  sha256 "0a9f97ac79b6f093a54e39a6b952bd8fec7ca4d7352abf2509c464fdbdb2a79b"

  bottle do
    cellar :any
    sha256 "79f63d221bd8158acd59e62b1c9d00155fe6e5dd7342b8c3146f268491a70573" => :mojave
    sha256 "2ed0b9633e3ca02f0bc7ccc828488135aae5184d05e9dab6c27f29e1c7ade18b" => :high_sierra
    sha256 "3abf1e40a8259d4bc10240547dee890a07eab6945f0c713eb3581461ad025884" => :sierra
    sha256 "ba9a99d87eca4aa356d506e5b6e14eb25bc5f47c8001114f82519b9dfbedf88e" => :el_capitan
    sha256 "ce81cb3942f040ea14406d3c2369e531605033b6173c36eada757f372c8d81f7" => :yosemite
  end

  depends_on "autoconf" => :build

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpdump", "-T"
  end
end
