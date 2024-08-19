class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.19/libupnp-1.14.19.tar.bz2"
  sha256 "b6423c573b758d09539f5e6c4712c1a9fd35dccf835f81d99473d50a50ad49b0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a069dc51847c08e45f0825690c3bb69071793480a2c80b03383800e9bbadf95"
    sha256 cellar: :any,                 arm64_ventura:  "d030fdfb72893d7ec2907a0b818c451d53fb5f56338fabac5103494bf47db81c"
    sha256 cellar: :any,                 arm64_monterey: "1e911c107c095edfb09d6a232ea98d7213e9274ef27c80bb5564af6b9fda824c"
    sha256 cellar: :any,                 sonoma:         "d8beb0fd061ff2ad26f725ec52e9682b2546db40f9cbe5e7875638a04a30980c"
    sha256 cellar: :any,                 ventura:        "22cd63291fff84a6aff14af36f2ede512db46c7fe9a85b95f6124b57d9cdc630"
    sha256 cellar: :any,                 monterey:       "07d61a52e633a7b249f51af157f6ed2740033661cdce75fe2f8547c80847c3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d78e9580d8c1a1997674d9943604b7a7b604959bb6b78f95ed5657b0b1b9a3c"
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
