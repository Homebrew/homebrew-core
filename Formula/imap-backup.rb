class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v4.0.7.tar.gz"
  sha256 "785dd28a6d2a33b2774ce09db30c41add5925d737f7840562a2e9b4fb7f9836d"

  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ac7f1a3c41b30dba92269af4f9baf89b4886e75be0896f75ee923d40e3b9628"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f72a3fe44b22389265183f5975115274276f8c534e4ead6d928f6cf073c5e3a7"
    sha256 cellar: :any_skip_relocation, monterey:       "7ac7f1a3c41b30dba92269af4f9baf89b4886e75be0896f75ee923d40e3b9628"
    sha256 cellar: :any_skip_relocation, big_sur:        "f72a3fe44b22389265183f5975115274276f8c534e4ead6d928f6cf073c5e3a7"
    sha256 cellar: :any_skip_relocation, catalina:       "f72a3fe44b22389265183f5975115274276f8c534e4ead6d928f6cf073c5e3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "356b64f9b6611dacf9ad9323b075f04687dcfee8f71277ad3cb6894e67926027"
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
