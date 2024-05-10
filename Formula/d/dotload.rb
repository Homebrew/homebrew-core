class Dotload < Formula
  desc "Tool for installing dotfiles and other required packages"
  homepage "https://github.com/okineadev/dotload"
  url "https://github.com/okineadev/dotload/releases/download/v1.2.1/dotload_1.2.1.tar.xz"
  sha256 "c0b77fe70b975451ff7211cb09ebe7765a3d4c48eac58335d71db27517deceac"
  license "MIT"

  def install
    bin.install "bin/dotload"
  end
end
