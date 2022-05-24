class Mscgen < Formula
  desc "Parses Message Sequence Chart descriptions and produces images"
  homepage "https://www.mcternan.me.uk/mscgen/"
  url "https://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz"
  sha256 "3c3481ae0599e1c2d30b7ed54ab45249127533ab2f20e768a0ae58d8551ddc23"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?mscgen-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "32bd04807a17b5b73bce02204ca643ac9a0071570a115cad2f6b4d50ef1b9a43"
    sha256 cellar: :any,                 arm64_big_sur:  "9482190b13b0f8f64ddc361d5ba2ed8401490700cb24c2947e47f8182ca10d17"
    sha256 cellar: :any,                 monterey:       "5aeba0e2de0b189cc4027e6c15eb05dca9920883b90c783796157fb8bbc2f790"
    sha256 cellar: :any,                 big_sur:        "662b9da17d8c911e9d24be48def9a222e7068386c0b482eca48248d127467e14"
    sha256 cellar: :any,                 catalina:       "315656cf5f9d72907591b4c8a91e635e6aa9b2116cadefe9fdd76db4cff7ae87"
    sha256 cellar: :any,                 mojave:         "1f194eb67147772b362ae5446b2e369b35ee9ffa935c8e22d37cdb4c1364349b"
    sha256 cellar: :any,                 high_sierra:    "0f125ab1fbaf04c670f252f05358771f1663b3fc59857bcfd855bbb52e01f88b"
    sha256 cellar: :any,                 sierra:         "08345683137541d79b6422afd2e269b1ab8c195722e5e71cffa6298a3986d563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "899b8d5bbf4591b17a642cc9aa4fb43015184ddf126747429c1022fc7af18d90"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gd"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-freetype",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
