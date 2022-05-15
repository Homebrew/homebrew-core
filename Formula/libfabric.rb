class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.15.1/libfabric-1.15.1.tar.bz2"
  sha256 "cafa3005a9dc86064de179b0af4798ad30b46b2f862fe0268db03d13943e10cd"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7fb98bd0eea6919a568313751f7bdf9eb6a5b15f9fcf2bfb1ef905a9b8ea4e67"
    sha256 cellar: :any,                 arm64_big_sur:  "d82b97de57d4f0a9b349146d64f7ea26e8a0f07492abbff8068be0c36309dfd4"
    sha256 cellar: :any,                 monterey:       "aeb1269f836ec62187a72ded9363f418c7eff706d8859365ef12faf5249b1971"
    sha256 cellar: :any,                 big_sur:        "0695c38a8fe0cf8c5be27e6aae62f35f6e8bafdaa7efdb5a74fc721973242ace"
    sha256 cellar: :any,                 catalina:       "6e08fc6af0323f5044624c5a6c716450cc620ba9cf10355637fc5b92fb9bee74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a368729a69fc759593d5be7625e5d0c40c53274fc6bbd3b704f048b034a484db"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
