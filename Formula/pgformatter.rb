class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v4.0.tar.gz"
  sha256 "2816d08655a554785fc55ccd299ad9613930872b7170df766d5da32dec47ce31"

  bottle do
    cellar :any_skip_relocation
    sha256 "864f59b8b06cc4b53bd6650c47c9ad759cdbd1e88dda66769a620f1447b9d27a" => :mojave
    sha256 "24abc2f70cc5a221bd25b641a90d95dcb439cfc30e0739ed82e198155234cc96" => :high_sierra
    sha256 "c2d42dd09ee6494902cace6bfe0cf204f0246ddaaf70c80095fbbcb22f83f3f0" => :sierra
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
