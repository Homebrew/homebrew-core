class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v3.0.tar.gz"
  sha256 "8cf2452d0e4a6448e86b80e9a0dbc9252729544150f3141d14192e33bc86fedb"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1f0fcb81b94ec4aa97a90a7110e793be409a9b44aea402989b5fbc61a133ce1" => :high_sierra
    sha256 "c1f0fcb81b94ec4aa97a90a7110e793be409a9b44aea402989b5fbc61a133ce1" => :sierra
    sha256 "c1f0fcb81b94ec4aa97a90a7110e793be409a9b44aea402989b5fbc61a133ce1" => :el_capitan
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    prefix.install (buildpath/"usr/local").children
    (libexec/"lib").install "blib/lib/pgFormatter"
    libexec.install bin/"pg_format"
    bin.install_symlink libexec/"pg_format"
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system "#{bin}/pg_format", test_file
  end
end
