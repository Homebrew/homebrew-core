class MysqlSearchReplace < Formula
  desc "Database search and replace script in PHP"
  homepage "https://interconnectit.com/products/search-and-replace-for-wordpress-databases/"
  url "https://github.com/interconnectit/Search-Replace-DB/archive/3.1.tar.gz"
  sha256 "837389799a2884e3f77a3ab84c1a4161b6e2220041f91c9f149529111babe676"

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
