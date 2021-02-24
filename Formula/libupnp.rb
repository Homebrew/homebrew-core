class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.1/libupnp-1.14.1.tar.bz2"
  sha256 "4cdc39ff9a65e324c6e4d5470c302cf904ac3cf23bdace36618ed5b44cd6080a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b1f237de939574c2c4e793fa678207bd05d22a215de0caf8353079aef307292d"
    sha256 cellar: :any, big_sur:       "92fc6f925846fbbb86f4015c98f50aa10179d63b5fc9db18fc62fd502585edb6"
    sha256 cellar: :any, catalina:      "b500f8ab453b1496f8a5ca83daf29a201114729bf8b6a5e60773aa9dffc1c7ce"
    sha256 cellar: :any, mojave:        "2a380ff4f135f0cade7152de5250ce257afd7e2f68527ebe64add7afc248ab83"
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
