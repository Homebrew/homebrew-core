class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v3.4.tar.gz"
  sha256 "1e504e67032d35ab6418a582cb106239e6a78a3fac75a5996db3bdb998d96889"

  bottle do
    cellar :any_skip_relocation
    sha256 "f93a3e3df7309520df02fb29f5ff386f52a6f081b6fec33e66d6ffa928b5e875" => :mojave
    sha256 "812ff63ece606b2edf98ae23afc75f00ea2ffd59f49eb67e6fd59d11000222ef" => :high_sierra
    sha256 "812ff63ece606b2edf98ae23afc75f00ea2ffd59f49eb67e6fd59d11000222ef" => :sierra
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
