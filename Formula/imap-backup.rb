class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "831580d804efa03cb7caac7a8fe8ff1626e73277c6149ca410d49e663f38ff50"
  license "MIT"

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    # fix gem.files here until it is fixed upstream
    inreplace "./imap-backup.gemspec" do |f|
      f.gsub!(%r{(require "imap/backup/version")},
              "\\1\nrequire 'rake/file_list'")
      f.gsub!(/(gem.files *=).*$/,
              "\\1 Rake::FileList['**/*'].exclude(*File.read('.gitignore').split)")
    end

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"imap-backup").mkdir
    PTY.spawn bin/"imap-backup setup" do |r, w, pid|
      r.winsize = [80, 43]
      sleep 1
      w.write "exit without saving changes\n"
      assert_match(/^Choose an action:.*$/, r.read)
    rescue Errno::EIO
      nil
    ensure
      Process.kill("TERM", pid)
    end
  end
end
