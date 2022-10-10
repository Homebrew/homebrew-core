class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.16.1/libfabric-1.16.1.tar.bz2"
  sha256 "53f992d33f9afe94b8a4ea3d105504887f4311cf4b68cea99a24a85fcc39193f"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2c53e73dfcd784dac33295e84ef45d35794260812f522dbb861d6fbb48f9970e"
    sha256 cellar: :any,                 arm64_big_sur:  "ed9144b5cb03292a358f4f89e2a7bf7c84d9974dc3dc39162648f70bd0c7c812"
    sha256 cellar: :any,                 monterey:       "d682d12e279871e48aa7b220cb6907b75d102762e3ea78f876a7c8f5c278edf4"
    sha256 cellar: :any,                 big_sur:        "e8ba210e6e61540e4a6e04550b62ba36642f9257bda038a804c1a72da1647fb3"
    sha256 cellar: :any,                 catalina:       "7e855780f1b7e8df553edfa62e2d9b02f708b108a86d74bdc96e1cb69e2cbbe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa089a18b7fde229d98e57c40e48f623e06870000137240d1c207f15374c8c88"
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
