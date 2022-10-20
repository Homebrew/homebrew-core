class BrewPhpSwitcher < Formula
  desc "Switch Apache / Valet / CLI configs between PHP versions"
  homepage "https://github.com/philcook/brew-php-switcher"
  url "https://github.com/philcook/brew-php-switcher/archive/v2.4.tar.gz"
  sha256 "305627aa4165e760f95453efc75c47027e7ecee233c1dd85911a692ca48549af"
  license "MIT"
  head "https://github.com/philcook/brew-php-switcher.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "93556c4acac08ee72bdc0bf5c12e220b18edb2396a5fdc28470b38ca04d5906a"
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
