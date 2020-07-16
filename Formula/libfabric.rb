class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.10.1/libfabric-1.10.1.tar.bz2"
  sha256 "889fa8c99eed1ff2a5fd6faf6d5222f2cf38476b24f3b764f2cbb5900fee8284"
  revision 1
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "74dc473f0008cde1d89de5f652712b45423ddf1fde9dbbc04fad370c682934ba" => :catalina
    sha256 "bd2f233361852bf42193a9af476aaa516b52060d2710553a198b1402b929bea9" => :mojave
    sha256 "c2e506d659ff3682a99e2cf4949e073ea531d0207220f863649ecf41d079a35a" => :high_sierra
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
