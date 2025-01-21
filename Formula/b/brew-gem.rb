class BrewGem < Formula
  desc "Install RubyGems as Homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "70af3a1850490a5aa8835f3cfe23a56863d89e84e1990c8029416fad1795b313"
  license "MIT"
  head "https://github.com/sportngin/brew-gem.git", branch: "master"

  # Until versions exceed 2.2, the leading `v` in this regex isn't optional, as
  # we need to avoid an older `2.2` tag (a typo) while continuing to match
  # newer tags like `v1.1.1` and allowing for a future `v2.2.0` version.
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8725b10550f4284125bd582c7c7e79cc732eaae73d5bf8e4475cf776030ea037"
  end

  uses_from_macos "ruby"

  def install
    inreplace "lib/brew/gem/formula.rb.erb", "/usr/local", HOMEBREW_PREFIX

    lib.install Dir["lib/*"]
    bin.install "bin/brew-gem"
  end

  test do
    system bin/"brew-gem", "help"
  end
end
