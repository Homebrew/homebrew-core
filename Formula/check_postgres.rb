class CheckPostgres < Formula
  desc "Monitor Postgres databases"
  homepage "https://bucardo.org/wiki/Check_postgres"
  url "https://bucardo.org/downloads/check_postgres-2.22.0.tar.gz"
  sha256 "29cd8ea0a0c0fcd79a1e6afb3f5a1d662c1658eef207ea89276ddb30121b85a8"
  revision 3

  head "https://github.com/bucardo/check_postgres.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cca947a07f41712768a1f50a7fcbabcb35d8585c5faf4564e6470181ff6d786" => :high_sierra
    sha256 "2cca947a07f41712768a1f50a7fcbabcb35d8585c5faf4564e6470181ff6d786" => :sierra
    sha256 "2cca947a07f41712768a1f50a7fcbabcb35d8585c5faf4564e6470181ff6d786" => :el_capitan
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
