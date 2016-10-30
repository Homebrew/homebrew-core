class PgTop < Formula
  desc "Monitor PostgreSQL processes"
  homepage "http://ptop.projects.postgresql.org/"
  url "http://pgfoundry.org/frs/download.php/3504/pg_top-3.7.0.tar.bz2"
  sha256 "c48d726e8cd778712e712373a428086d95e2b29932e545ff2a948d043de5a6a2"

  bottle do
    cellar :any
    sha256 "91b171e0653b1e77a416a4d5ab59f28daaaf5b24cdeaf9b9e88cea81b5f24c81" => :sierra
    sha256 "f6942875416fa688254e82feac6f0991cab3181ca0a545bce53ca4af9dc856f3" => :el_capitan
    sha256 "2e1a209d75f91eea0f22dc6e9c391c95a65289436d5060df7cc803bec8c3df35" => :yosemite
    sha256 "6d9c0960d9594b6643126ef60ecdae71b21b8ab9ebdcd6d0a7efc9a1847dab87" => :mavericks
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
