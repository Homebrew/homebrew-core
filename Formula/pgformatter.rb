class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v2.1.tar.gz"
  sha256 "f18d67e2e6ed45b164c5efdbadb82d07c65e0ba6cc93e039b39ecfdd5ff54ce8"

  bottle do
    cellar :any_skip_relocation
    sha256 "761c0bfee8e1a2e87f08a724cc608a87371021c3cc3e9d897a7df66a308d8654" => :sierra
    sha256 "443714343ee9f2c7f4ae613e5c07869dc22e4297e72d77ec5c8b6f44efb9544b" => :el_capitan
    sha256 "443714343ee9f2c7f4ae613e5c07869dc22e4297e72d77ec5c8b6f44efb9544b" => :yosemite
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
