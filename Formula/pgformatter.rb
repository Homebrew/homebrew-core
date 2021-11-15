class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v5.1.tar.gz"
  sha256 "9d9974f70002e12ea12344d4373202a637572729c297f3f85e51fb2f60519997"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bde351c61b9e139948bc1188cc1ec8a4e2f8afa97b00f5549283162cb4f935f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ed75c0fecbdcf5fdc4232888cecd5201b03d1d9c1640d19cf805c61931e3176"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb7acff043a08195b0f216a32b926d28e7d10bc36a72aa0977500fc4fcacb09"
    sha256 cellar: :any_skip_relocation, big_sur:        "597a79f382e5be9ec4af90f3e1499686686912c10092943f659c65b31e97b46c"
    sha256 cellar: :any_skip_relocation, catalina:       "34ea80e6142dfee05233d417713cc517545f7b62555ccf40997acb7b52431383"
    sha256 cellar: :any_skip_relocation, mojave:         "34ea80e6142dfee05233d417713cc517545f7b62555ccf40997acb7b52431383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b7ec5b32bafedef008190142250d561b0c577081db09e8df889a101294dc0cb"
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
