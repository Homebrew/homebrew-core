class PgTop < Formula
  desc "Monitor PostgreSQL processes"
  homepage "http://ptop.projects.postgresql.org/"
  url "https://www.mirrorservice.org/sites/ftp.postgresql.org/projects/pgFoundry/ptop/pg_top/3.7.0/pg_top-3.7.0.tar.bz2"
  mirror "http://pgfoundry.org/frs/download.php/3504/pg_top-3.7.0.tar.bz2"
  sha256 "c48d726e8cd778712e712373a428086d95e2b29932e545ff2a948d043de5a6a2"
  revision 2

  bottle do
    cellar :any
    sha256 "530371a7cbfe45c075cc7211630aa35d1e3aad3ba6c5e6f8611349baaf805dfc" => :sierra
    sha256 "55384b673ebc22e89c093b70809b5ea796fdcc72c492d89a68468a51b1a2943a" => :el_capitan
    sha256 "3c2dbc3fe9610a43cc4171c7d9d0d65a02c57d24d37f67208b12ead8654ae95f" => :yosemite
  end

  depends_on :postgresql

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    (buildpath/"config.h").append_lines "#define HAVE_DECL_STRLCPY 1" if MacOS.version >= :mavericks
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pg_top -V")
  end
end
