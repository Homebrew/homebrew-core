class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.8.1.tar.gz"
  sha256 "0d2330e3c46ce21d7fa3d29f0f99b9527eb5ab323b1efb9b1a0e6915779c74d6"
  license "MIT"
  head "https://github.com/clibs/clib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52cf863b9e04e981a75a67b53d05b8a64c76f61db19e18bc6d5b4e0352cad370"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f8eaaa858e78080be30fcf73cfe83db9da902547e199dd3c8a5c0dba708d0d8"
    sha256 cellar: :any_skip_relocation, monterey:       "fa20d76a03c5150eb6fc7babde0d599f8f23846f114fde49c4c459f5391e2441"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4ee7dffee98a71bb8bd190b919e31406e7ae9981f1b6496f54c7931eb87945a"
    sha256 cellar: :any_skip_relocation, catalina:       "a5d05d90aa5d488a82f1b53776944a4f3efc257c991e19e9dce8f393efed39e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4427aa47bd0a56a0e35e70943ba8bc160cb8a83cac9f59378574aa234584e8f7"
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
