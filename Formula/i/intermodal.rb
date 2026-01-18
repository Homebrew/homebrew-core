class Intermodal < Formula
  desc "Command-line utility for BitTorrent torrent file creation, verification, etc."
  homepage "https://imdl.io"
  url "https://github.com/casey/intermodal/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "a01fde996f2e506c7e90a6015a6e130cb4757d21e98063c38672bdccf2e99d9c"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be891c2b96611a332b05e919ae9bd4d94bc353f649fc907954a49a649d3eb1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840aa130a61ca1f89c05b615b20aa43ec80df2229406895455b4521796dd6f48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c711d051f9fdfcf2b6e910d3101f0e25811532c0caa0a964f204f144b1cc996e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e113d9474e825dc7e86a67360e1f713a515aef547c52008c6ede62611576aac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c308e078efd80e3ef65cf6db4d62a87272d2897d960b4c41a10fd9350edd05a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b50de11de888eb84d65e2ff265bd6a16effc63be4ef067cf71bb3cbb6cda22a4"
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "run", "--package", "gen", "--", "--bin", bin/"imdl", "man"
    generate_completions_from_executable(bin/"imdl", "completions")

    man1.install Dir["target/gen/man/*.1"]
  end

  test do
    system bin/"imdl", "torrent", "create", "--input", test_fixtures("test.flac"), "--output", "test.torrent"
    system bin/"imdl", "torrent", "verify", "--content", test_fixtures("test.flac"), "--input", "test.torrent"
  end
end
