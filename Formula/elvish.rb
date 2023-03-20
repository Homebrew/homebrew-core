class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "ef8032507c74c84369d49b098afcf1da65701aa071be9ee762f8bc456576ac94"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9dd4b68d9a4c944bd4f16540d281149f23052e9049cc1d56c98c0c10869ba45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c8b6065d78d525706b0e7a36368a2d5f74f1af434f54c71108b9db816386381"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5cdcd6f5140d8926857ecf93b1a38968f58ebb74692cc3a2beb894da554b893"
    sha256 cellar: :any_skip_relocation, ventura:        "52e99d52ff2ec57564b9534143c966692a156c8beb3efcd031e2f0342e1b9f98"
    sha256 cellar: :any_skip_relocation, monterey:       "79dcb84093d07d2937e0667f0b089926299ad35d7453b23d27f9285db36f5b82"
    sha256 cellar: :any_skip_relocation, big_sur:        "278eb08f2ea14fcf9f57ad5b75508bdfc01ab14729c4db34cb1cadd46044b1a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a65fd8f49f47fb279ffdb460db56a91ab9efa533bcf17e4a8edeae280cff3d25"
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
