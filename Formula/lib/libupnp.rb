class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.17/libupnp-1.14.17.tar.bz2"
  sha256 "9b877242eba0428c7f949af4d6e7b7b908ce5ebc67cc13475ee6eb0d9bcb6ffb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4be98a44a777b54ca4786eed738fd4aa9f12b4cb16b9845d72f1b59ea6a1f8e1"
    sha256 cellar: :any,                 arm64_monterey: "4ad5bf36120ce3ec544abf63e5ccd4722a2fc6d274c8152b3a589c0d96b3638d"
    sha256 cellar: :any,                 arm64_big_sur:  "72d5be8f13d0654f149da24a2bd195ba3e7925d780aa499b61785060e87dff9d"
    sha256 cellar: :any,                 ventura:        "739b92568ec0008b0eb8b367ff5f68322493eb415646ee738a8e1f499b22b92f"
    sha256 cellar: :any,                 monterey:       "94b552c6b276ce5f894dc7e1bd5ff60e03c404c1bc448e14f79269bd0014fdfe"
    sha256 cellar: :any,                 big_sur:        "13a1fc538b20cf36bdab6854905484a175b5d8063558ebe50f92aa645c340bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c03de0340be1621fb628bf7f646e9a4596161fe33fbc0886f10edc297723c98a"
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
