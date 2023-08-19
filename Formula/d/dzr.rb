class Dzr < Formula
  desc "Command-line Deezer.com player"
  homepage "https://github.com/yne/dzr"
  url "https://github.com/yne/dzr/archive/refs/tags/230730.tar.gz"
  sha256 "8feebabc002a0520b65bc3a6256ad81c4446d5b54d6c8fac71176b9bb9c764cc"
  license "Unlicense"
  head "https://github.com/yne/dzr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfdafe4626cdd00cc33931951f88e43af51493a0b6a0e90baca956ff19855c4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfdafe4626cdd00cc33931951f88e43af51493a0b6a0e90baca956ff19855c4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfdafe4626cdd00cc33931951f88e43af51493a0b6a0e90baca956ff19855c4b"
    sha256 cellar: :any_skip_relocation, ventura:        "bfdafe4626cdd00cc33931951f88e43af51493a0b6a0e90baca956ff19855c4b"
    sha256 cellar: :any_skip_relocation, monterey:       "bfdafe4626cdd00cc33931951f88e43af51493a0b6a0e90baca956ff19855c4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfdafe4626cdd00cc33931951f88e43af51493a0b6a0e90baca956ff19855c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd4b5c6e6c8649454f1d07ab5163728ebdb3bdfc4c9134be007b7817f8d40068"
  end

  depends_on "dialog"
  depends_on "jq"
  depends_on "mpv"
  uses_from_macos "curl"

  def install
    bin.install "dzr", "dzr-url", "dzr-dec", "dzr-srt", "dzr-id3"
  end

  test do
    ENV.delete "DZR_CBC"
    assert_equal "3ad58d9232a3745ad9308b0669c83b6f7e8dba4d",
                 Digest::SHA1.hexdigest(shell_output("#{bin}/dzr !").chomp)
  end
end
