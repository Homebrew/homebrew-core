class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.16/libupnp-1.14.16.tar.bz2"
  sha256 "6cb2b1019e41be06032f6932070d37d2051a84ea68a035837b28dbf8cdc60dd9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1ea5267caaa9c0c09c722f55a28b64bd0bcd5a5b1f008b4f04b8125f4a1eab4a"
    sha256 cellar: :any,                 arm64_monterey: "597ac4f05e80c9e68406cbe371add27891c659de0f345bec0e73712660a7a019"
    sha256 cellar: :any,                 arm64_big_sur:  "d87f614b7d70d01d4c9e507469e9c7736f6ee18b90283700b02a4a271c576871"
    sha256 cellar: :any,                 ventura:        "bd8092ea5266cc4cec353b75bc8a38d5577447a7de9d9da11b68eb4a93459f86"
    sha256 cellar: :any,                 monterey:       "8fe8e07fe38a36c8fb602a172dbc5a5e8979213a8f2f0de7c737d329e925d68f"
    sha256 cellar: :any,                 big_sur:        "57fa19f105132fb722d7e2c1a57fce0c97681992091ce1700be09ba3616403a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c1b78aabf54226f63972ae523e5b9e39f1f0be03bc7936a7de5932bc9bd23a"
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
