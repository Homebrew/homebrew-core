class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.2/libupnp-1.14.2.tar.bz2"
  sha256 "ffe3045b91a4c951d105e0db98cd043341f1f4342ddaf23916e15a5792d5c270"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0a4bb3015934cc4b82b65f54cf3938024b478b5f91c05451ef055f805db6d26e"
    sha256 cellar: :any, big_sur:       "a8490a19a9efda5274e37e4e6cd7430b15e5b24b80a7462aceecd2b9f9056d00"
    sha256 cellar: :any, catalina:      "e5e62207372fdf55e27e79e243002824bc8d0dc2c6836de617d5a8236c560c50"
    sha256 cellar: :any, mojave:        "ce61c494f03d24f8082f41b8edce3ebde7355b07977fdbe0e68179cf1025258a"
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
