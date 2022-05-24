class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v5.2.tar.gz"
  sha256 "78bfc77f54f33d948f9b2e2cd061ceee0b970e263a403603635cfec61e955ae0"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18b1513504f1939029ec9ebf722e04bae563820168f5f24b142bb1e33d73038f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2828aed1d21971a93897d6a25d3f3e4ac440348ff733fb638179a963d5a6e5a"
    sha256 cellar: :any_skip_relocation, monterey:       "522fc9941d5b0f75f606b21a861f223b1936ae23518de214956cba730c80acc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a10d8651dfec5a4c58304105bd92da391a07d39f7df6e14a772f3b4901d83584"
    sha256 cellar: :any_skip_relocation, catalina:       "dde68d30f85eed7ae33dabe850464afe90035e5d5fe01e17c7c544d7415927f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a884b1b995cbf67af35c229c5467ab59319a9e765ff1e64e4568f66bd24a50a4"
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    if OS.linux?
      # Move man pages to share directory so they will be linked correctly on Linux
      mkdir "usr/local/share"
      mv "usr/local/man", "usr/local/share"
    end

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
