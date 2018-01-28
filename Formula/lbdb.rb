class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb_0.46.tar.gz"
  sha256 "b13f23fd71c1f059a27db65a37c77daa9751e66354e017637663a234bb00dd99"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6afe8aedfafc7b8ac1bc1e766d3d8ecabc3c6cff576b6f217b2859bb1256e35" => :high_sierra
    sha256 "ec24bdf809b1226a1c5ffe6b805b58f70551fbde5529cd68321be71c43c17a7e" => :sierra
    sha256 "a78fabea88eaa0265505a6034f70988338e433bd0f6f70f8a6e4c4d3d317b185" => :el_capitan
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
