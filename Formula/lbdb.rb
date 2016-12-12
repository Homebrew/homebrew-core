class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/debian/lbdb_0.42.1.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/lbdb/lbdb_0.42.1.tar.xz"
  sha256 "fe03bfc922b06febd8da261003070e335680d7fdf9ebd513c04a92a37731df2d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1193c2651e556beeb66443d562803ffe076e6c64e7fa25c8031369549965deee" => :sierra
    sha256 "0011a9c8c337268496c32f21c1e620431219f47b7aea069eecaad0f9cbc651b2" => :el_capitan
    sha256 "2c7ee40068170ce3943be138ac4a91e8116322f9f3d098319af3b41cb3072a6f" => :yosemite
  end

  depends_on "abook" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
