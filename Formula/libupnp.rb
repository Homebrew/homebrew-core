class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.0/libupnp-1.14.0.tar.bz2"
  sha256 "ecb23d4291968c8a7bdd4eb16fc2250dbacc16b354345a13342d67f571d35ceb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ab146b72831a64ee990f311d4894b020550f241095d2adcc030642d2324afd99"
    sha256 cellar: :any, big_sur:       "13f2cab18c8b12b11802c2bd8dd0cf62b15c44e8f3ad008f2acc679d112adb11"
    sha256 cellar: :any, catalina:      "f687168c37ba09bb0ee06b2d0d373c6de2f8d5511c563191788e45282fd104af"
    sha256 cellar: :any, mojave:        "b7e3d1d7fc0a4011e093f040f71578f549e06b7702d9ec29c9595fb11fa206f6"
    sha256 cellar: :any, high_sierra:   "70340bed620fd9c537881d58a6b0f720689fbf0ebf9dbfa9acfdb846190e9c69"
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
