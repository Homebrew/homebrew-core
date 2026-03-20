class Checkpwn < Formula
  desc "Check Have I Been Pwned and see if it's time for you to change passwords"
  homepage "https://github.com/brycx/checkpwn"
  url "https://static.crates.io/crates/checkpwn/checkpwn-0.5.6.crate"
  sha256 "c7540e67a6d25bf68926084d76a09866a9fb9eb265a2b4c21802fcbf741b51d4"
  license "MIT"
  head "https://github.com/brycx/checkpwn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f60a7bc5c125f61b2cab9356ffb94c54655aa3703390fd3ff0d0b5e101685da3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e2e9e8589e7d5308ff7a9f5cebf138f6626156619720537afd7f7c698d4ae1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3d99626488af00d24f67479269952d059c0f3463fc40acc15cf556a596cf312"
    sha256 cellar: :any_skip_relocation, sonoma:        "272889e72f9c64d14c59701570c09ec879b94a96d7ad5c770b84769b91a04d31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b2101b67785e0305f6d22d080ec36b31f9a816f266708d5af36d828792237d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "702e2b2968002c784aab3ab98eb71305ce82e36ac060844cb57d8acecfcfea6b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/checkpwn acc test@example.com 2>&1", 101)
    assert_match "Failed to read or parse the configuration file 'checkpwn.yml'", output
  end
end
