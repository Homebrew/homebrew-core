class CheckPostgres < Formula
  desc "Monitor Postgres databases"
  homepage "https://bucardo.org/wiki/Check_postgres"
  url "https://bucardo.org/downloads/check_postgres-2.25.0.tar.gz"
  sha256 "11b52f86c44d6cc26e9a4129e67c2589071dbe1b8ac1f8895761517491c6e44b"
  license "BSD-2-Clause"
  head "https://github.com/bucardo/check_postgres.git"

  livecheck do
    url "https://bucardo.org/check_postgres/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2f164aefe3706e144350278db4e9246359a8a58bba1f16fae289344553e33b64" => :catalina
    sha256 "2f164aefe3706e144350278db4e9246359a8a58bba1f16fae289344553e33b64" => :mojave
    sha256 "e0ae2298e162d333e8833ad294906ba369ac5adaf704b8478ebf54c7a134b9f4" => :high_sierra
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
