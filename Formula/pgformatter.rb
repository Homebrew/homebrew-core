class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v3.3.tar.gz"
  sha256 "f56ff7d7b8d59e85ac325a4b954d98b6aeae8369da74970f7948c7f4a1448ffa"

  bottle do
    cellar :any_skip_relocation
    sha256 "151286785ab2ee342fa33663e89ecec9892771c6bc86ec93f835b486e954d168" => :mojave
    sha256 "43e152a13a17b2dad47598f490bedbfc1a149ccb9e28e7c259330fc3ec934680" => :high_sierra
    sha256 "43e152a13a17b2dad47598f490bedbfc1a149ccb9e28e7c259330fc3ec934680" => :sierra
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
