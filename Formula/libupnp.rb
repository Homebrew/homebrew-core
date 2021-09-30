class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.12/libupnp-1.14.12.tar.bz2"
  sha256 "091c80aada1e939c2294245c122be2f5e337cc932af7f7d40504751680b5b5ac"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "498de8b894e9d5edc65b98f64d2b2f27f45bdc937a42853368b7a0d4c508a0c9"
    sha256 cellar: :any,                 big_sur:       "60b3842a7bfca0288765248e4785db736d7ba5eea72c9297e82dc18b7166c34f"
    sha256 cellar: :any,                 catalina:      "cb0d28b216635f82886afef84a80a6754ca63ebe37adda9bcd200fec0511a0be"
    sha256 cellar: :any,                 mojave:        "0fb1a0b939e0df28c85285ec16992ea9cbf3c52b67de6a5a354e9aca3bc69f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c294556aaacfc246b87ad96596497476581e5534980b4fe6fc99f3c890491a30"
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
