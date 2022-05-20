class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.3/hfst-ospell-0.5.3.tar.bz2"
  sha256 "01bc5af763e4232d8aace8e4e8e03e1904de179d9e860b7d2d13f83c66f17111"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "39ee3dc725cb4535ab7750e6f9f029526c99dbd36272d3bebad6bd29cc1c94e6"
    sha256 cellar: :any,                 arm64_big_sur:  "7b19c0410b74db35223a040b64d82fa5cbadba8f887c628b91088dfff5ff24ab"
    sha256 cellar: :any,                 monterey:       "670813eb672ef2483f9a4e445bedadd75a45f20c6e4285740b5f95a4c676c638"
    sha256 cellar: :any,                 big_sur:        "b29f67a02688c05044d90f26e34f9e741b99d51d6573f5e2a687f43370eaa265"
    sha256 cellar: :any,                 catalina:       "934c5346eef7db979bc0dfc2ef6945731b58433fd5f223e5d4eb736207eadb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8528124f05e18a4bc62ba750c190b6264bf8b7cbdc11032426844a20dc1b42fe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libarchive"

  def install
    ENV.cxx11
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-libxmlpp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hfst-ospell", "--version"
  end
end
