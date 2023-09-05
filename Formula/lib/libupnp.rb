class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.18/libupnp-1.14.18.tar.bz2"
  sha256 "16a7cee93ce2868ae63ab1a8164dc7de43577c59983b9f61293a310d6888dceb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ead88b1f594f71ef15f68e019dbec93b7175f3af98ca448bfa9c2b5080a5388"
    sha256 cellar: :any,                 arm64_monterey: "e31564f5a608faa7e7dd487f139d1dcf7ef659b7cd2740808a804bc34a07d8ea"
    sha256 cellar: :any,                 arm64_big_sur:  "09b1dedb2e530eeabe741eff79f030bbb267a9c01fc6a3d100e95edb4ff8a67c"
    sha256 cellar: :any,                 ventura:        "336cd47cb806b78cdae13a672dd763f163758e03be355a7598468069ccd2be31"
    sha256 cellar: :any,                 monterey:       "cf5074234cd7285d767ca0edef639f592cedbcb2efb0b2f065d5114c7bd986bb"
    sha256 cellar: :any,                 big_sur:        "485b3dab9fbf366fc3fcd944a9f2bafdf92d97b0d2cd0f0d339c2156c330d13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01347124ad1761e82777487db178b1655928bf6e7b8319c95da7a184628522cf"
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
