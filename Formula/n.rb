class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v8.1.0.tar.gz"
  sha256 "adf97836bfd66e79776b1330e84b9f089f73e9e89d3a6fd6e385a95d3eab2af5"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54fb0e61bcd717cfd807d422985396dc3841870064205013895fa5928acb94bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54fb0e61bcd717cfd807d422985396dc3841870064205013895fa5928acb94bf"
    sha256 cellar: :any_skip_relocation, monterey:       "daf8a144b8334522a1a43eac4e1d82eee64667e3e54e0e3eaddb69fb02b9ced1"
    sha256 cellar: :any_skip_relocation, big_sur:        "daf8a144b8334522a1a43eac4e1d82eee64667e3e54e0e3eaddb69fb02b9ced1"
    sha256 cellar: :any_skip_relocation, catalina:       "daf8a144b8334522a1a43eac4e1d82eee64667e3e54e0e3eaddb69fb02b9ced1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54fb0e61bcd717cfd807d422985396dc3841870064205013895fa5928acb94bf"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
