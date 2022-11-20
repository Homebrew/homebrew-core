class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.15/libupnp-1.14.15.tar.bz2"
  sha256 "794e92c6ea83456f25a929e2e1faa005f7178db8bc4b0b4b19eaca2cc7e66384"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5eb26f40c9a8373f0f7b0288781061770524ad9cb7bf4efa5f5e57d627d048b"
    sha256 cellar: :any,                 arm64_monterey: "2d1d07350af6f887b39c65d3b15a02dfa0cf6900bb55b9d1d9fd8aa35ff12bb3"
    sha256 cellar: :any,                 arm64_big_sur:  "49b8f0978e19bd5a9b56523a2b9f900b26c945f447a52b619f2c5ce100665dd8"
    sha256 cellar: :any,                 ventura:        "2a806b2965507a2d3aeeaa6c2408b5a64b1e5b2887924d1447904b3f25883919"
    sha256 cellar: :any,                 monterey:       "e908e95cc65ef9656699437cd2f2aa5c65334bdb306746d309ff94bacb4e5a0f"
    sha256 cellar: :any,                 big_sur:        "cbdd7bb3928ff35f2d2c055e39fa8d638b9d11ca50a62f89d61eec6a961e29e5"
    sha256 cellar: :any,                 catalina:       "87e8de3c1a19addae2a49ecaf99b14f4abbbde0cc4ed252aed278d6bb6e86f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8b86de307422d877d05eff6a92ea5cf2674a7265f00576a65636eef7b35b559"
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
