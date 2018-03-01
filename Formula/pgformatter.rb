class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v3.0.tar.gz"
  sha256 "8cf2452d0e4a6448e86b80e9a0dbc9252729544150f3141d14192e33bc86fedb"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9590bb8095b1f672ebc0c13c581d929423df77299ab646955d8b0525276e302" => :high_sierra
    sha256 "819bef7e3febfe60cfa23cf71bee347815ab244e5971ac068bbd4386570545d6" => :sierra
    sha256 "819bef7e3febfe60cfa23cf71bee347815ab244e5971ac068bbd4386570545d6" => :el_capitan
    sha256 "819bef7e3febfe60cfa23cf71bee347815ab244e5971ac068bbd4386570545d6" => :yosemite
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
