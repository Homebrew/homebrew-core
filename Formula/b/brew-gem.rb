class BrewGem < Formula
  desc "Install RubyGems as Homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "e8c9d25447ef8f5dda7437d2429392ed5ffea321385b4b4f37296d89c015d5b5"
  license "MIT"
  head "https://github.com/sportngin/brew-gem.git", branch: "master"

  # Until versions exceed 2.2, the leading `v` in this regex isn't optional, as
  # we need to avoid an older `2.2` tag (a typo) while continuing to match
  # newer tags like `v1.1.1` and allowing for a future `v2.2.0` version.
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef38079c55d47695e059adeed9a24ca3921ef4f33712c1c5ca7d963c6750a55b"
  end

  uses_from_macos "ruby"

  def install
    lib.install Dir["lib/*"]
    bin.install "bin/brew-gem"
  end

  test do
    system bin/"brew-gem", "help"
  end
end
