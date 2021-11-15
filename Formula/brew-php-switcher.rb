class BrewPhpSwitcher < Formula
  desc "Switch Apache / Valet / CLI configs between PHP versions"
  homepage "https://github.com/philcook/php-switcher"
  url "https://github.com/philcook/brew-php-switcher/archive/v2.3.tar.gz"
  sha256 "5e6a622354422c66737ac6b76c6ea2db6d1591558a0238d680ba530f2c8b5773"
  license "MIT"
  head "https://github.com/philcook/brew-php-switcher.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ff0c773aa993b39343b501b7d5fca1355249bfce4e4d6a068ea30c6490ddbb7b"
  end

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
