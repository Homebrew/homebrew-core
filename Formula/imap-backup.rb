class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v4.0.7.tar.gz"
  sha256 "785dd28a6d2a33b2774ce09db30c41add5925d737f7840562a2e9b4fb7f9836d"

  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30a7edef536c81d396da408696674b4679eed38dfc26c7354b4d67413e26b403"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97ca77aaa06555c3ff753ce7a428952cf4802abf8f29ac223c66c7d6e920a0d6"
    sha256 cellar: :any_skip_relocation, monterey:       "30a7edef536c81d396da408696674b4679eed38dfc26c7354b4d67413e26b403"
    sha256 cellar: :any_skip_relocation, big_sur:        "97ca77aaa06555c3ff753ce7a428952cf4802abf8f29ac223c66c7d6e920a0d6"
    sha256 cellar: :any_skip_relocation, catalina:       "97ca77aaa06555c3ff753ce7a428952cf4802abf8f29ac223c66c7d6e920a0d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4bd02540b773b898a4e884c877ff443c00d8387af7b34e5b5566253ef6d6935"
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
