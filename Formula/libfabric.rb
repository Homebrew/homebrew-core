class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.10.1/libfabric-1.10.1.tar.bz2"
  sha256 "889fa8c99eed1ff2a5fd6faf6d5222f2cf38476b24f3b764f2cbb5900fee8284"
  # license ["BSD-2-Clause", "GPL-2.0"] - pending https://github.com/Homebrew/brew/pull/7953
  license "BSD-2-Clause"
  revision 2
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

  # https://github.com/ofiwg/libfabric/pull/6109 is merged upstream, remove this with next release
  patch do
    url "https://github.com/ofiwg/libfabric/commit/85c9732fd95f9970f5bcf793ca580d45ed7418f2.diff?full_index=1"
    sha256 "d5beec5d57be89e0ab53aad44912af98172a85fd894d38a16330cd01dd92ae5b"
  end

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
