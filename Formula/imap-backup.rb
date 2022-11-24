class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "02b1fa9752c0211490f6289e160d575fe7c3c5c00f1860256f4f75b2a5c320e9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f55e1eeb092d9dc1df76fa12ca2259f639f114985d9f9ae657e59344820835e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b2c5faa3e32d58ca5dce78c163d4f55c56f3d9fbb71eee2c2f3447f5b261e04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83cbc01a4f863a5775557850dc0b364dc62dfa8bdaaab31f4b954586c9ec87db"
    sha256 cellar: :any_skip_relocation, ventura:        "1f55e1eeb092d9dc1df76fa12ca2259f639f114985d9f9ae657e59344820835e"
    sha256 cellar: :any_skip_relocation, monterey:       "9b2c5faa3e32d58ca5dce78c163d4f55c56f3d9fbb71eee2c2f3447f5b261e04"
    sha256 cellar: :any_skip_relocation, big_sur:        "83cbc01a4f863a5775557850dc0b364dc62dfa8bdaaab31f4b954586c9ec87db"
    sha256 cellar: :any_skip_relocation, catalina:       "83cbc01a4f863a5775557850dc0b364dc62dfa8bdaaab31f4b954586c9ec87db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75bec77483adc5372490d935e01dba477826483337732d9a37057a74a7fb64d5"
  end

  uses_from_macos "ruby", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Choose an action:", pipe_output(bin/"imap-backup setup", "3\n")
  end
end
