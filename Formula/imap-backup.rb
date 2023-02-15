class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v9.0.2.tar.gz"
  sha256 "f85fa08452ed17007727b3f27a90cae8fdc8a5c4de9173e39a3e2d4f62170795"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f27b927f2fce256817275cef8648f98177733be00123bfbd1e5962c01ce9428b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f27b927f2fce256817275cef8648f98177733be00123bfbd1e5962c01ce9428b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f27b927f2fce256817275cef8648f98177733be00123bfbd1e5962c01ce9428b"
    sha256 cellar: :any_skip_relocation, ventura:        "f27b927f2fce256817275cef8648f98177733be00123bfbd1e5962c01ce9428b"
    sha256 cellar: :any_skip_relocation, monterey:       "f27b927f2fce256817275cef8648f98177733be00123bfbd1e5962c01ce9428b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f27b927f2fce256817275cef8648f98177733be00123bfbd1e5962c01ce9428b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09024334ca05a93c9a8b97c337c89a9ef92f3cb6a1e5cbf8d6c2c2aee289cf18"
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
