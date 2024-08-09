class MysqlSearchReplace < Formula
  desc "Database search and replace script in PHP"
  homepage "https://interconnectit.com/products/search-and-replace-for-wordpress-databases/"
  url "https://github.com/interconnectit/Search-Replace-DB/archive/refs/tags/4.1.2.tar.gz"
  sha256 "3da4b2af67bb820534c0e8d8dc6b87f4b38be6fe2410df90177a39dc24ae4593"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08b03d69eae7a4b2f89ead89f79ac09cd0bd093da29e0255329c308fd559ff43"
  end

  depends_on "php"

  # Build patch for php 8.3+, upstream pr ref, https://github.com/interconnectit/Search-Replace-DB/pull/385
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/8ca0dd3a1af4e6d08484d9421db058db1b21f225/mysql-search-replace/4.1.2-php-8.3.patch"
    sha256 "24d99a3834de335fdb40d86fac617602187f184a886e1cc6b381de80a2ba67d0"
  end

  def install
    libexec.install "srdb.class.php"
    libexec.install "srdb.cli.php" => "srdb"
    chmod 0755, libexec/"srdb"
    bin.install_symlink libexec/"srdb"
  end

  test do
    system bin/"srdb", "--help"
  end
end
