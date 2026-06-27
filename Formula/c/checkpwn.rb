class Checkpwn < Formula
  desc "Check Have I Been Pwned and see if it's time for you to change passwords"
  homepage "https://github.com/brycx/checkpwn"
  url "https://static.crates.io/crates/checkpwn/checkpwn-0.6.0.crate"
  sha256 "483f848624bcba52a409c3043fae702ba0e90ed4e0cdf44e18e9897574abc5d3"
  license "MIT"
  head "https://github.com/brycx/checkpwn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "247d39a4ed73db6c07ea0f9d401779401d65fc8b8b57b6c4f07bcb87770b698e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e93af1bcf4bd347443e44c0fbb5455481985deb338766f2fbcdff9fcf9a8da6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a75b7f8e6f8231893f90fb2399e863d87f738ae3fcc9fb90d2d7e8c62544087c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d482bbc30d4ed2ff6c947c75205dcfe60485bcc549bcc46a1662b53c8221adb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c68a5a8ba299cfe05ced5b08e46e659e9d0c95c3bb4ed610b2cbe8ed87f47489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8acec269fbd8bb8623f7354a658670649c8f1cedc28bf0f68b50db4d523e0f7c"
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
