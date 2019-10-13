class CheckPostgres < Formula
  desc "Monitor Postgres databases"
  homepage "https://bucardo.org/wiki/Check_postgres"
  url "https://bucardo.org/downloads/check_postgres-2.24.0.tar.gz"
  sha256 "79d4efb2d82a91dd8e7c077c323d1a25d64435bcaecfc3bba0cf0bb5e3ea1e17"
  head "https://github.com/bucardo/check_postgres.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5de792e7b22657a7d34b0c20ae20994c2ff9967870d2361a96af3c9ecde973a" => :catalina
    sha256 "eed2892822abe3b006befc6f7933040b8deec32074c9729408c6c4f4765efce8" => :mojave
    sha256 "eed2892822abe3b006befc6f7933040b8deec32074c9729408c6c4f4765efce8" => :high_sierra
    sha256 "56fbaf773772a3424d6c1d532c9f5f691c1f4d85e4a0bc62ef880a28bae87f5a" => :sierra
  end

  depends_on "postgresql"

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "install"
    mv bin/"check_postgres.pl", bin/"check_postgres"
    inreplace [bin/"check_postgres", man1/"check_postgres.1p"], "check_postgres.pl", "check_postgres"
    rm_rf prefix/"Library"
    rm_rf prefix/"lib"
  end

  test do
    # This test verifies that check_postgres fails correctly, assuming
    # that no server is running at that port.
    output = shell_output("#{bin}/check_postgres --action=connection --port=65432", 2)
    assert_match /POSTGRES_CONNECTION CRITICAL/, output
  end
end
