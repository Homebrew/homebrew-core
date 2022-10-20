class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.14/libupnp-1.14.14.tar.bz2"
  sha256 "3ae23a2f2dbe3c4fe845a14d114d092743dac1184d024a8e900c2d3e78362150"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b877e17c89ba5b82171fd94be62a3c80be42dadc479ea08c34cc3815506e84a9"
    sha256 cellar: :any,                 arm64_big_sur:  "44a2da9c5a0fd8de2017ce9611aaf8a340392f7cef8b58325b9e54d8d1b75e73"
    sha256 cellar: :any,                 monterey:       "0c126e6ad4315134e0ebc48921b42cd2cf755706b26d7b85a7850e8349c14982"
    sha256 cellar: :any,                 big_sur:        "07fc86dd9f4c1c0c376602e7dc72e28a82b59b617a498d2adcee40cb97cc9814"
    sha256 cellar: :any,                 catalina:       "748e5dce20bac22a30e258fb8a78981ca83d17930d5d0480185822c5e0dc3249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06d6717c0e721d527eb437b87cd41580213a7343be274faa10072af14a3cd4d0"
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
