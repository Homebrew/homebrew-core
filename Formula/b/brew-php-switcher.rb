class BrewPhpSwitcher < Formula
  desc "Switch Apache / Valet / CLI configs between PHP versions"
  homepage "https://github.com/philcook/brew-php-switcher"
  url "https://github.com/philcook/brew-php-switcher/archive/refs/tags/v2.5.tar.gz"
  sha256 "a14414488275a64d82d1837e766e77c094577f7c5ee02ec89dc35baba236bd3e"
  license "MIT"
  head "https://github.com/philcook/brew-php-switcher.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e0825664daa7aa3179f0893c1293a4db3c9fc7255f23f4c84b5a3d9e7f3f2f0a"
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
