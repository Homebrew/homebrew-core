class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v4.3.tar.gz"
  sha256 "ab5fecbfa463221f2a0dc457437a2d0fe98e4ee63c1ee15f0ce10286d97bd636"
  license "PostgreSQL"

  bottle do
    cellar :any_skip_relocation
    sha256 "c456132a750decd8e9283605f3c2315e00cdf1256cf82fd346205aaf46de3012" => :catalina
    sha256 "c456132a750decd8e9283605f3c2315e00cdf1256cf82fd346205aaf46de3012" => :mojave
    sha256 "a09bb4b78a53f3f953ac502388d198d837a84cb0aad9a2a8659b53f5f79eeb54" => :high_sierra
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
