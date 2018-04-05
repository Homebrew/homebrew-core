class BrewPhpSwitcher < Formula
  desc "Switch Apache / Valet / CLI configs between PHP versions"
  homepage "https://github.com/philcook/php-switcher"
  url "https://github.com/philcook/brew-php-switcher/archive/v2.0.tar.gz"
  sha256 "c2303b1b1a66ee90ed900c3beabacd6aa4e921dbcad5242e399c45d86899bc88"

  bottle :unneeded

  depends_on "php" => :test

  def install
    bin.install "phpswitch.sh"
    bin.install_symlink "phpswitch.sh" => "brew-php-switcher"
  end

  test do
    expected_output = <<~EOF
      usage: brew-php-switcher version [-s|-s=*] [-c=*]

          version    one of: 5.6,7.0,7.1,7.2
          -s         skip change of mod_php on apache
          -s=*         skip change of mod_php on apache or valet restart i.e (apache|valet,apache|valet)
          -c=*         switch a specific config (apache|valet,apache|valet
    EOF
    assert_match expected_output, shell_output("#{bin}/brew-php-switcher")
  end
end
