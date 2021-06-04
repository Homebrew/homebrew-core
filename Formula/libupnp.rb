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
    sha256 cellar: :any, arm64_big_sur: "edb6dcac4526a882c43ff359bd0db338a1333c35a9e6f6d1e128c5d1b068da04"
    sha256 cellar: :any, big_sur:       "4de43bda6cb5e423e870e4370ba0d27ac405e2aa9a6b2a0cefe85d84db752ed0"
    sha256 cellar: :any, catalina:      "29a30b62d04826dbf6b534a6309e2b223296f92a5ce11c1a2c13fa0e4eea0fef"
    sha256 cellar: :any, mojave:        "ceea5e06f6c0fbc313d6b29420ae3bf287aa59cea395536e5b0bd97c62dbee14"
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
