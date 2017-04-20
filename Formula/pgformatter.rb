class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v1.6.tar.gz"
  sha256 "a389d1a848fab553dbaa5648b6eb78a70a98ae59e26338183b1eb826c40566da"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fff476eedd9427bbc6449a0627c780818a92783f3aa9962cc7576bf7ab0b326f" => :sierra
    sha256 "fff476eedd9427bbc6449a0627c780818a92783f3aa9962cc7576bf7ab0b326f" => :el_capitan
    sha256 "405df8d8d9148c1f41b47d2839a764b2510e6a12bfa9be2a05cdd7d426866bba" => :yosemite
  end

  def install
    # Fix path to Perl modules. Per default, the script expects to
    # find them in a lib directory beneath it's own path.
    inreplace "pg_format", "$FindBin::Bin/lib", libexec

    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    bin.install "blib/script/pg_format"
    libexec.install "blib/lib/pgFormatter"
    man1.install "blib/man1/pg_format.1"
    man3.install "blib/man3/pgFormatter::Beautify.3pm"
    man3.install "blib/man3/pgFormatter::CGI.3pm"
    man3.install "blib/man3/pgFormatter::CLI.3pm"
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system "#{bin}/pg_format", test_file
  end
end
