class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.11.0/libfabric-1.11.0.tar.bz2"
  sha256 "9938abf628e7ea8dcf60a94a4b62d499fbc0dbc6733478b6db2e6a373c80d58f"
  license ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "b51064b2aaeaa0a29ecea4847c4e3c9bb0728b3689d36f9ce28380245473b15a" => :catalina
    sha256 "c430f0b1809ab1b674d686649d484969c1da5fe10ef5c1e51ecb603290e2a800" => :mojave
    sha256 "926207089e78be7ae450684b1152979d549fda911fbbe660603f3690c8f37315" => :high_sierra
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
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
