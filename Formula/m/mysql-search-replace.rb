class MysqlSearchReplace < Formula
  desc "Database search and replace script in PHP"
  homepage "https://interconnectit.com/products/search-and-replace-for-wordpress-databases/"
  url "https://github.com/interconnectit/Search-Replace-DB/archive/refs/tags/4.1.4.tar.gz"
  sha256 "f753d8d70994abce3b5d72b5eac590cb2116b8b44d4fe01d4c3b41d57dd6c13d"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "83006f9192e3961c1251b9c11f255afe703ae3076598b2b148e211c18b6dba41"
  end

  depends_on "php"

  def install
    libexec.install "srdb.class.php"
    libexec.install "srdb.cli.php" => "srdb"
    bin.write_exec_script libexec/"srdb"
  end

  test do
    system bin/"srdb", "--help"
  end
end
