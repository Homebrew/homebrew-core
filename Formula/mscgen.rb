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
    sha256 cellar: :any,                 big_sur:      "662b9da17d8c911e9d24be48def9a222e7068386c0b482eca48248d127467e14"
    sha256 cellar: :any,                 catalina:     "315656cf5f9d72907591b4c8a91e635e6aa9b2116cadefe9fdd76db4cff7ae87"
    sha256 cellar: :any,                 mojave:       "1f194eb67147772b362ae5446b2e369b35ee9ffa935c8e22d37cdb4c1364349b"
    sha256 cellar: :any,                 high_sierra:  "0f125ab1fbaf04c670f252f05358771f1663b3fc59857bcfd855bbb52e01f88b"
    sha256 cellar: :any,                 sierra:       "08345683137541d79b6422afd2e269b1ab8c195722e5e71cffa6298a3986d563"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "899b8d5bbf4591b17a642cc9aa4fb43015184ddf126747429c1022fc7af18d90"
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
