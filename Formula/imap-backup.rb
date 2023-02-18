class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v9.1.0.tar.gz"
  sha256 "bc0a846439e65327aafe1dc6dbe5f514a4e503e0eaeba79584ac097a7cc4c9a7"
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
