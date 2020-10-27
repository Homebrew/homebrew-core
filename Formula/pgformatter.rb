class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v4.4.tar.gz"
  sha256 "7db5451064425fb13ff86a723654dcedc6554b62cbf5777bc65f30ffbf833480"
  license "PostgreSQL"

  bottle do
    cellar :any_skip_relocation
    sha256 "afcce813b73ebaa9326790850289abdfeba332e4be86c6e55fcec6220b66bbef" => :catalina
    sha256 "d991b9830807c92d78108a2320a358d162db5749b97bcdb8dea846058392c97c" => :mojave
    sha256 "86e00ee2a7f917e6e0e8c7409c788267faeb710b4c707f4a6463bcd0c2dd0fae" => :high_sierra
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
