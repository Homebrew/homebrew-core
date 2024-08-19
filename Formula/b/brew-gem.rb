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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "694721fcbd4b8c2c8d7db6135ca73aadf0cfe63646a1bfa9dc917d2fd138597a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "694721fcbd4b8c2c8d7db6135ca73aadf0cfe63646a1bfa9dc917d2fd138597a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "694721fcbd4b8c2c8d7db6135ca73aadf0cfe63646a1bfa9dc917d2fd138597a"
    sha256 cellar: :any_skip_relocation, sonoma:         "694721fcbd4b8c2c8d7db6135ca73aadf0cfe63646a1bfa9dc917d2fd138597a"
    sha256 cellar: :any_skip_relocation, ventura:        "694721fcbd4b8c2c8d7db6135ca73aadf0cfe63646a1bfa9dc917d2fd138597a"
    sha256 cellar: :any_skip_relocation, monterey:       "694721fcbd4b8c2c8d7db6135ca73aadf0cfe63646a1bfa9dc917d2fd138597a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5249679d614de6163b40a3a676d3895635ca03c916b35837c0d8ad701ecbd71a"
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
