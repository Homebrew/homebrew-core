class PgTop < Formula
  desc "Monitor PostgreSQL processes"
  homepage "http://ptop.projects.postgresql.org/"
  url "https://www.mirrorservice.org/sites/ftp.postgresql.org/projects/pgFoundry/ptop/pg_top/3.7.0/pg_top-3.7.0.tar.bz2"
  mirror "http://pgfoundry.org/frs/download.php/3504/pg_top-3.7.0.tar.bz2"
  sha256 "c48d726e8cd778712e712373a428086d95e2b29932e545ff2a948d043de5a6a2"
  revision 3

  bottle do
    cellar :any
    sha256 "6da4637b35a5e5e6f7c58971d133a51800f38f4ca7e6295bbb8ac87009f9dd81" => :high_sierra
    sha256 "07dbd4e11e14f831ffaec7a7194603f4614400739c8aa7dfe228ebe274013622" => :sierra
    sha256 "e5ede71b29f9dd48ba48b29573583e641bc74f4c4646c9376487977d08ee5eaa" => :el_capitan
    sha256 "67d208940d439990fc04c04512f3ca42efc518c118ebaf8969fd396fca37ecad" => :yosemite
  end

  depends_on "postgresql"

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
