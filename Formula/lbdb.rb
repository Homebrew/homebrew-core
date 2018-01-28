class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb_0.46.tar.gz"
  sha256 "b13f23fd71c1f059a27db65a37c77daa9751e66354e017637663a234bb00dd99"

  bottle do
    cellar :any_skip_relocation
    sha256 "18945a7d0504c07fd2ac34ad81cfe03e20d6f7ac20c83d5db1f901f46628c9eb" => :high_sierra
    sha256 "33744d9ff2776be0cf9d39b795fbd719fa244c1489a8e88b800cfc50d8ca1e79" => :sierra
    sha256 "fdb4728b6f181bf072532d65e84215c9fb8f9e3a6ab1403bfb33b2476a25f51c" => :el_capitan
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
