class BrewPip < Formula
  desc "Install pip packages as homebrew formulae"
  homepage "https://github.com/hanxue/brew-pip"
  url "https://github.com/hanxue/brew-pip/archive/0.4.1.tar.gz"
  sha256 "9049a6db97188560404d8ecad2a7ade72a4be4338d5241097d3e3e8e215cda28"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3231885b29ff349dfcee4f83a375f5d0ce4643750ea61d40a64a9ca0373ab71b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3231885b29ff349dfcee4f83a375f5d0ce4643750ea61d40a64a9ca0373ab71b"
    sha256 cellar: :any_skip_relocation, monterey:       "d2cc472aef77f711ebb4890a1f669e9d7bf1668c5e024ef97b8e09fb8e6565aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2cc472aef77f711ebb4890a1f669e9d7bf1668c5e024ef97b8e09fb8e6565aa"
    sha256 cellar: :any_skip_relocation, catalina:       "d2cc472aef77f711ebb4890a1f669e9d7bf1668c5e024ef97b8e09fb8e6565aa"
    sha256 cellar: :any_skip_relocation, mojave:         "d2cc472aef77f711ebb4890a1f669e9d7bf1668c5e024ef97b8e09fb8e6565aa"
  end

  def install
    bin.install "bin/brew-pip"
  end

  test do
    system "#{bin}/brew-pip", "help"
  end
end
