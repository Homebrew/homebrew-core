class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v4.3.tar.gz"
  sha256 "ab5fecbfa463221f2a0dc457437a2d0fe98e4ee63c1ee15f0ce10286d97bd636"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7af4ea0fb76eaf00600648b08e4c12d93ecacbb0b7886233117a5aa5f6181eb" => :catalina
    sha256 "b7af4ea0fb76eaf00600648b08e4c12d93ecacbb0b7886233117a5aa5f6181eb" => :mojave
    sha256 "3fa7887f4c73c61c23a3bb535042849f3db128adbf4f63c7d5ced622c3d284e0" => :high_sierra
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
