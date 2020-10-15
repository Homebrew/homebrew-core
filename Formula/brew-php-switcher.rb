class BrewPhpSwitcher < Formula
  desc "Switch Apache / Valet / CLI configs between PHP versions"
  homepage "https://github.com/philcook/php-switcher"
  url "https://github.com/philcook/brew-php-switcher/archive/v2.2.tar.gz"
  sha256 "505bc355cd725cacd048e44b60eadb5ad88c31f3c9d311e4b250c274aa78c14c"
  license "MIT"
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
