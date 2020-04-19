# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class ComposerSwitcher < Formula
  desc "Composer Mirror Repository Switcher"
  homepage "https://www.github.com/persiliao/composer-switcher"
  url "https://github.com/persiliao/composer-switcher/archive/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "8a2911dbdad2f6dfc036b6e55a5c79bc57aa1b35c6a5736ef6780b9f599e701a"

  depends_on "composer"

  def install
    bin.install "composerswitcher.sh"
    bin.install_symlink "composerswitcher.sh" => "composer-switcher"
  end

  test do
    assert_match "usage: composer-switcher", shell_output("#{bin}/composer-switcher")
  end
end
