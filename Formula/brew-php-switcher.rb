class BrewPhpSwitcher < Formula
  desc "Switch Apache / Valet / CLI configs between PHP versions"
  homepage "https://github.com/philcook/php-switcher"
  url "https://github.com/philcook/brew-php-switcher/archive/v2.1.1.tar.gz"
  sha256 "5a812761d1c0a89f243533a3bad31eb2c6f0b0c9ad93b3ae3307dbd99e890464"
  head "https://github.com/philcook/brew-php-switcher.git"

  bottle :unneeded

  depends_on "php" => :test

  def install
    bin.install "phpswitch.sh"
    bin.install_symlink "phpswitch.sh" => "brew-php-switcher"
  end

  test do
    assert_match "usage: brew-php-switcher version",
                 shell_output("#{bin}/brew-php-switcher")
  end
end
