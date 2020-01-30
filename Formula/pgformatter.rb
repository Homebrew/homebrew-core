class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v4.2.tar.gz"
  sha256 "54780782d74ca1c8b3a183c53a7a95a8cc8789ddb3690f757c7e992d1cc364a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b23bf542e1da32dfd10dcf3879df51a45e78c623454b8b34542a8f520217682" => :catalina
    sha256 "0b23bf542e1da32dfd10dcf3879df51a45e78c623454b8b34542a8f520217682" => :mojave
    sha256 "bef33156d170aa02ac039710f44838c12c45ddb80f76b591561169e9db0e1f8d" => :high_sierra
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
