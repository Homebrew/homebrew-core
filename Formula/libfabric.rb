class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.15.0/libfabric-1.15.0.tar.bz2"
  sha256 "70982c58eadeeb5b1ddb28413fd645e40b206618b56fbb2b18ab1e7f607c9bea"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "67e1890e5424205e4d47db665aef0c9f197e5e1648b7d3371d1f5902ce72241c"
    sha256 cellar: :any,                 arm64_big_sur:  "2dfe3c2fad7e8a913c2919989627bc8401ac84994ec3381e4261ad110263e636"
    sha256 cellar: :any,                 monterey:       "213f99b7bf3755739201a7d19c2871381a92ec60bdd174990c8308cfb57a4ec5"
    sha256 cellar: :any,                 big_sur:        "5753837b80e8fa3494ba685738d51b5e6193b8258ee1f4951a1f44637ff36b15"
    sha256 cellar: :any,                 catalina:       "683db1d11a19802de82992e96b212ae749e6a82627819f45f20d02f2d6723420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61554857ee7be51161c443afa9859ec41dce2acd6de8a2ea263a884e71ee95b4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
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
