class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.20/libupnp-1.14.20.tar.bz2"
  sha256 "ee4b4f85aa00ce38b782cf480fa569a90c7ccb23b0a9a076073a2d0bd6227335"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca104359eb9176e483930dee375887341728384ff9f5363c1b083b9263a50e64"
    sha256 cellar: :any,                 arm64_sonoma:  "d503a737a2fcf0a9f06c14fa541e8bc2bce9725f90e94a5faf2db18c58118c59"
    sha256 cellar: :any,                 arm64_ventura: "b6203d369767093f428fa82b59f87b34b3689b77e38cd0054690703585d13f18"
    sha256 cellar: :any,                 sonoma:        "916337db6468d0d513d72ec4b0400ba2c52aec5d8b695b557d4be9a9f4bd4a74"
    sha256 cellar: :any,                 ventura:       "1fa4a3c05cc76204ba8054574e66c5fe2b111d8c78b454ef12eb43e69f4024fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd6a610c48cb262cea7510c9ea45d222f23cad77fd8213320094ef39794e40c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24255556551c29174438ffd4102facea726932fb7d38219d1745615f60e30ff9"
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
