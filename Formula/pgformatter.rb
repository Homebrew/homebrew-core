class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v2.0.tar.gz"
  sha256 "ef2f7bc124a694c0384b6bda661582ad2dae7c25b289aba596a23fb17dd5f130"

  bottle do
    cellar :any_skip_relocation
    sha256 "761c0bfee8e1a2e87f08a724cc608a87371021c3cc3e9d897a7df66a308d8654" => :sierra
    sha256 "443714343ee9f2c7f4ae613e5c07869dc22e4297e72d77ec5c8b6f44efb9544b" => :el_capitan
    sha256 "443714343ee9f2c7f4ae613e5c07869dc22e4297e72d77ec5c8b6f44efb9544b" => :yosemite
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
