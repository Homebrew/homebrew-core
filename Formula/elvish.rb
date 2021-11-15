class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.16.3.tar.gz"
  sha256 "ea9d594070cff58ed9caedf4619ee195bfce179f79b9a8d5e7a635ce5cbba551"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d622f7dbe863693b07eb3a03335d6633d952f924d2af276bc2cd3c915961607"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22868343fa4e1cf95ff4c59c5a7d88216fd497e3c1ef4bce63ebd80919725cb2"
    sha256 cellar: :any_skip_relocation, monterey:       "408a773e781c66875487fbc1a9eb97cdd9f6d42f29301ffbc199112a17e84747"
    sha256 cellar: :any_skip_relocation, big_sur:        "baca586af00fca196d69e0e8b1b3309df1c0b8f7d72e4089fc20f8e1a2a1bbb4"
    sha256 cellar: :any_skip_relocation, catalina:       "86453d36b3aed50cab567de1a763204f0162eb8b41ac039c7061c94cdaca630d"
    sha256 cellar: :any_skip_relocation, mojave:         "c345a3ec54ff058d8fbd86a97948412e811785ccefe097b3defeb0061eaf0946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7397b282b7170800c11579efe0bce701861703966dccc32113dc870345ca43e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      *std_go_args(ldflags: "-s -w -X src.elv.sh/pkg/buildinfo.VersionSuffix="), "./cmd/elvish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
