class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "18733f7222e21035f8d7b0bcdaba1c805b543fb465e307d991b950aaab659705"

  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35bae1e10bfb8cd0ade9520e4822653721a9fa4571e29c5c7cbb63f178ccb849"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "876347b7a37e2e7db1bf45ffea4ee86d642e32906e9160c9330ae6881c58d886"
    sha256 cellar: :any_skip_relocation, monterey:       "35bae1e10bfb8cd0ade9520e4822653721a9fa4571e29c5c7cbb63f178ccb849"
    sha256 cellar: :any_skip_relocation, big_sur:        "876347b7a37e2e7db1bf45ffea4ee86d642e32906e9160c9330ae6881c58d886"
    sha256 cellar: :any_skip_relocation, catalina:       "876347b7a37e2e7db1bf45ffea4ee86d642e32906e9160c9330ae6881c58d886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2f4f0f591cc0947dcb826a67ea47959a04402e5db5ce7814a3c11c17ac508e5"
  end

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    # workaround from homebrew-core/Formula/pianobar.rb
    on_linux do
      # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    require "pty"
    PTY.spawn bin/"imap-backup setup" do |r, w, pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "exit without saving changes\n"
      assert_match(/Choose an action:/, r.read)
    ensure
      Process.kill("TERM", pid)
    end
  end
end
