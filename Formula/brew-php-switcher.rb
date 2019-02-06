class BrewPhpSwitcher < Formula
  desc "Switch Apache / Valet / CLI configs between PHP versions"
  homepage "https://github.com/philcook/php-switcher"
  url "https://github.com/philcook/brew-php-switcher/archive/v2.1.tar.gz"
  sha256 "40e036d87a781e9e987a5f5a5b5024a336706bd8afdb2962dfb4d54955bb46de"
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
