class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/0.6.1.tar.gz"
  sha256 "1830a6b66d9ea020ecd2ca544007f53e95037694560d4bf446993210c36401ed"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2281b513b08d39705e7924217983be78786eefc212d5efaab9930d309fe9aeed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d716b07a4a1a661f56e761acdf190287e09a27815c4f3b7c54cd0a4a255a1ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "035737131ee4b06a9d8b1292582354696d31b31f6e599a403a0710735376cc55"
    sha256 cellar: :any_skip_relocation, ventura:        "21e07da503989b664a6f161b7733fcdbb6e88397edc75cdac2c24787a8005ee1"
    sha256 cellar: :any_skip_relocation, monterey:       "b3472de54c43bc4c0b0502b71a682cc47c567f7b2e0cdde8fc2c08aebf92fcea"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6516a2b2e6680075f417c64d927b160e1fd7db8e13f577f290b25fb9abe615e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34a6f6fce30d88c053ebe5ea3446848fcbcb1a866c73790da4038a9672ebee0d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
