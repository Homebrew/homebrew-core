class BrewGem < Formula
  desc "Install RubyGems as Homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/v1.1.1.tar.gz"
  sha256 "affa68105dcabc5c8b4832cf70ee2b35c1fbf19496173753645bda496d9b0a34"
  license "MIT"
  head "https://github.com/sportngin/brew-gem.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc319ba05f5f17b0f516292f5fb2d55eccb6c03a11cacc438b1c2c2fb5ccb0db"
  end

  def install
    inreplace "lib/brew/gem/formula.rb.erb", "/usr/local", HOMEBREW_PREFIX

    lib.install Dir["lib/*"]
    bin.install "bin/brew-gem"
  end

  test do
    system "#{bin}/brew-gem", "help"
  end
end
