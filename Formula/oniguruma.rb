class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.7.1/onig-6.9.7.1.tar.gz"
  sha256 "6444204b9c34e6eb6c0b23021ce89a0370dad2b2f5c00cd44c342753e0b204d9"
  license "BSD-2-Clause"
  head "https://github.com/kkos/oniguruma.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-](?:mark|rev)\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8b32f5922207998b2c90b6b03796b1831f5d491fb09d214bdf5d9393114de185"
    sha256 cellar: :any, big_sur:       "822090a56cfd19f6fa3b2aecffa2ff29c6bee3eb5d3e349bd4a5dc1a9a218ba4"
    sha256 cellar: :any, catalina:      "d9e578029ccb646a908d07906d7f749b83fbfc1fb94e5ab0b13c4cdb9100ccc4"
    sha256 cellar: :any, mojave:        "ae496b74f528333b5fd8142513d581de829d93ff52d8d79b3bf1e8a711f39935"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/#{prefix}/, shell_output("#{bin}/onig-config --prefix"))
  end
end
