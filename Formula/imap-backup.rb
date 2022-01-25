class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "6e72a20b04e6850abf1aac579a6a781850adb7b827394df31415a32ecc325856"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7f3f4918f04f91c8886915143f3f3eaadfbff2a8573cc0ab87d207d7a3f8659"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b80774c002678442c2549a7c92e18ea697bb53389f29d5649d0eb553e28aee6c"
    sha256 cellar: :any_skip_relocation, monterey:       "d7f3f4918f04f91c8886915143f3f3eaadfbff2a8573cc0ab87d207d7a3f8659"
    sha256 cellar: :any_skip_relocation, big_sur:        "b80774c002678442c2549a7c92e18ea697bb53389f29d5649d0eb553e28aee6c"
    sha256 cellar: :any_skip_relocation, catalina:       "b80774c002678442c2549a7c92e18ea697bb53389f29d5649d0eb553e28aee6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a1e70905f484257a17dd3e4d6ac8915ac5f43dcd82c37369b892b99536d47b5"
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
