class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/refs/tags/v5.6.tar.gz"
  sha256 "21a7f958cd3fe5d9c7851a882948278440bc9fd609e1a79ed5b8cf613d267fab"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a96e7ddda61fab03d6dd3ecac2ebf62a0342d1d53b66b24101e012241e4dfe31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a96e7ddda61fab03d6dd3ecac2ebf62a0342d1d53b66b24101e012241e4dfe31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb7e8053fc84262c6514411081df0468ba5d3b487133bfe6584ee3c0421cbc6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "490179e8a81e00b47ad1e798df25009fa4b17cd5a0e0bf209a5b05f12933a67f"
    sha256 cellar: :any_skip_relocation, ventura:       "462fff310c1dabda0ae24884c4bf25c61d8e3d9efe589bdf10581847160234e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a5af8f5f719b5c58be11c02afa9eff6dc15e249b7f22431a5118d7005912e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a5af8f5f719b5c58be11c02afa9eff6dc15e249b7f22431a5118d7005912e1b"
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
    system bin/"pg_format", test_file
  end
end
