class BrewGem < Formula
  desc "Install RubyGems as Homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "3ecb65806f7c4ea3140185dc90e0699f3d22c4b34926142f38c4d5abe5e2d2c2"
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
    sha256 cellar: :any_skip_relocation, all: "d15fe230ba2d3b46a3239c2c8308771f4602d1367ca09a26e87fc0b402432e54"
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
