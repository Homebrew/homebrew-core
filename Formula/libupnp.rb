class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.7/libupnp-1.14.7.tar.bz2"
  sha256 "7b66ac4a86bc0e218e2771ac274b2945bc4154bf9054e57b14afb67c26ac7c24"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0b2ea47defd1e5c95aa962205741158fa8a57dc07e9148bc547f394b84ecf02a"
    sha256 cellar: :any, big_sur:       "31da1e0e95056781f80af7179b22082fc8a9a3a343944ef6030517ba706a6dd0"
    sha256 cellar: :any, catalina:      "635bb6431799dc93fc755eea42f91f69d455741786a71aa932bdf066ede54fa9"
    sha256 cellar: :any, mojave:        "9a488673951bb9bd81b1112d5c451c329dc1479e12d3d1d7fee3d780d3648364"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
