class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v4.1.tar.gz"
  sha256 "935a0db3ab541eb3d08f52288f9958e4af14e289614d1ac4580d3aafb51d917a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0cfc5513c412218952a4efafc8b044fd254ed7236170598c7d928d6a183e48f" => :mojave
    sha256 "bced76b0fe3ecd889dd517396585f6683e8fd250698dc69361677114b16b0880" => :high_sierra
    sha256 "aeada48f43efd49f1796b457d8993060f4f6e87ba38ad2b7f38a9d3f47ba9def" => :sierra
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
