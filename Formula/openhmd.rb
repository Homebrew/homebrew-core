class Openhmd < Formula
  desc "Free and open source API and drivers for immersive technology"
  homepage "http://openhmd.net"
  url "https://github.com/OpenHMD/OpenHMD/archive/0.2.0.tar.gz"
  sha256 "b5be787229d7c7c5cb763cec6207f9814b0bb993c68842ef0a390184ca25380d"
  head "https://github.com/OpenHMD/OpenHMD.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cee3cb751d0bc2312f23a0a8747abab8b7b85e199deb8a36de6aee97a61c85e8" => :sierra
    sha256 "50917839a2a060a9a350dad6117bc3bc946a37c129774a4c8e2be89aa9ecec16" => :el_capitan
    sha256 "7d50acf26200c9ef86554a79ec610d745ce6c5b4188cd882b00222ec3faa5fea" => :yosemite
    sha256 "d3b4293c6c9f9979cf36e259da2775065c8732107f54f12a7bf55d08d9a2ac79" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "hidapi"

  conflicts_with "cspice", :because => "both install `simple` binaries"
  conflicts_with "libftdi0", :because => "both install `simple` binaries"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"tests").install bin/"unittests"
  end

  test do
    system pkgshare/"tests/unittests"
  end
end
