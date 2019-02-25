class CheckPostgres < Formula
  desc "Monitor Postgres databases"
  homepage "https://bucardo.org/wiki/Check_postgres"
  url "https://bucardo.org/downloads/check_postgres-2.24.0.tar.gz"
  sha256 "79d4efb2d82a91dd8e7c077c323d1a25d64435bcaecfc3bba0cf0bb5e3ea1e17"
  head "https://github.com/bucardo/check_postgres.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bb41d490549f9dd7f98dfbbd9da8d0faf59770eae547cd4b891473dfc20feaa" => :mojave
    sha256 "6d722bc7277678495996ecaecf62f5b61ea5de5f225286cab5ad36be3d467a9a" => :high_sierra
    sha256 "6d722bc7277678495996ecaecf62f5b61ea5de5f225286cab5ad36be3d467a9a" => :sierra
    sha256 "6d722bc7277678495996ecaecf62f5b61ea5de5f225286cab5ad36be3d467a9a" => :el_capitan
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
