class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.3/hfst-ospell-0.5.3.tar.bz2"
  sha256 "01bc5af763e4232d8aace8e4e8e03e1904de179d9e860b7d2d13f83c66f17111"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b83894e6f757d2d1b18e0bd83047439ab0d7f703121ef047387b864675cd868"
    sha256 cellar: :any,                 arm64_monterey: "c7b5948e7a4caaea3057a8061053f8e9b3a8b32ed015d7edefdc6caf7899956c"
    sha256 cellar: :any,                 arm64_big_sur:  "b5ba83ad32aaa4c038750c5cfead97970889687e32377a9f9515d7f03558d973"
    sha256 cellar: :any,                 ventura:        "3acf368122d040b744f29d61e822248d88ac550b8b92cab6bfb660afc74600d4"
    sha256 cellar: :any,                 monterey:       "19f185fe6d452aa2f65aaa7b9b2cfad1d3da91bca96438be291f415b66ce6c9e"
    sha256 cellar: :any,                 big_sur:        "4af2f521c16b4a7f1b15fc6b2b09712c6cf7f4b61224acd95d7943a2ca71ad83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95f22241ed5cd286609cb3c7aa25892686d937714db4e39243470a871f9e0cf3"
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
