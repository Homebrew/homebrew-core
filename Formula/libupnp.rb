class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.5/libupnp-1.14.5.tar.bz2"
  sha256 "227ffa407be6b91d4e42abee1dd27e4b8d7e5ba8d3d45394cca4e1eadc65149a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b22ef8411f7861e8d252dd700a8ecf95dd1f109b87c5b7f7decffd6f60fc8829"
    sha256 cellar: :any, big_sur:       "49f132e42eb2dbd6da02b432b9465aa4cf72ba279aa6c28360841dc41eef2b39"
    sha256 cellar: :any, catalina:      "3ba39a71e1a6e3592334112624defea5432bbd615cc3c2e7e533b6a908d0ed09"
    sha256 cellar: :any, mojave:        "d7ccdaa6752f766d26dc7f67126e44c4541c625f6e90c4e5e31c7df420bfda6d"
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
