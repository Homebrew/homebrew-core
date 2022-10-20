class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v5.3.tar.gz"
  sha256 "ad709a2c92c763d54088ae3f3002276a962ea25b5aa29ae16dd57e10f51b66f9"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "958626095788cd522c949b42f4ef80bf79c1fd05c31c9389f5b4a1a03d28cadd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7eefcaea365b20a43a68c55b20aea88c660f633e92b97355bf1db0bb66a296ed"
    sha256 cellar: :any_skip_relocation, monterey:       "e07e4d8a053f0126dfa50c082c14a589d7cec6781d2abb53fc37aa737e2b3bad"
    sha256 cellar: :any_skip_relocation, big_sur:        "d38e00a17190b05a85276c2b77f1cdfe3c6dd79f46183a862cb383cdd4abd8b3"
    sha256 cellar: :any_skip_relocation, catalina:       "e475bf116f1638ceafe659f0dd8685a70b9b2466256e927de8d14dd8655a7b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7668280d5d9f12f618f69b9af999ba49fb65adfe640e4ff0eb2551d575e3af67"
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
