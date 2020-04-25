class MysqlSearchReplace < Formula
  desc "Database search and replace script in PHP"
  homepage "https://interconnectit.com/products/search-and-replace-for-wordpress-databases/"
  url "https://github.com/interconnectit/Search-Replace-DB/archive/4.1.1.tar.gz"
  sha256 "7146d479f1774b564c81e48e869e4da9dce282653d0d34316be0bb54669ed126"

  bottle :unneeded

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
