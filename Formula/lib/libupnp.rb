class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.25/libupnp-1.14.25.tar.bz2"
  sha256 "36fdf15767573f4f92320f01b3fd3c1cb41732b91cfc24d10d1e6a55969c9f56"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "360141c2706cce5d6a0451c9f4d9ae7e14383dd83fb66f41a8918c45f4bba201"
    sha256 cellar: :any,                 arm64_sequoia: "468c09a1be1ce44a21ef96e19d3b5eada7e67e21fad3a50009d75a6a2694d4ad"
    sha256 cellar: :any,                 arm64_sonoma:  "623db204707afa24ca30a3518b4ad6ab6c099e4b1be92cd0264233cb86d43be6"
    sha256 cellar: :any,                 sonoma:        "7130d304fabaf146b19915f2f1e9b0d2869545eeca81b4d1e78f7a353799267b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3faca352cc7364847400764d9cf2ba7c0bc4aa95c1b39b324a4d6e51e12f449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87dc1f1da59721e2d77e701bac5bbb9f85d134f7591d1672e1ad2746da14ad55"
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
