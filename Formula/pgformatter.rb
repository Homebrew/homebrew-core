class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v5.4.tar.gz"
  sha256 "d0d922863594ca46ceca6fe9cb9d2f6dfef505c9732add505a02e9e630d3c4a6"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1aac1d52dc2962a6ab1d941b266ae611549e25b275ffdce88a7e606b8ddf78bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aac1d52dc2962a6ab1d941b266ae611549e25b275ffdce88a7e606b8ddf78bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "421bea7cd89ef84473ad0ac59ec9619d276f0535c628f047105b5ece2ba45b7c"
    sha256 cellar: :any_skip_relocation, ventura:        "f33ef9982bcba1931fdf3f3031d1a66d859fb3616bcd839c2b243584218625b7"
    sha256 cellar: :any_skip_relocation, monterey:       "f33ef9982bcba1931fdf3f3031d1a66d859fb3616bcd839c2b243584218625b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ef6bdf4c8989f4c64f7866d6f1994b42ec986b7e31bd06f68204103140c2add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a59e5e67acc43d57a72a56211d8a50a8fe1561652dce28c490110f91582c1001"
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
