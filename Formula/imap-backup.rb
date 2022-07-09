class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v6.0.1.tar.gz"
  sha256 "6af5abb733117adc93b820681e236b4947e29f411065810661fa2f1fee54f179"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23ebd53b6f96b4c1114a63b771efdc2e321bdd8d68d2827d2bccffb5c4176572"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad44d062359f8df5be66fb95f351dabe68e3ea3ae319a7ed8a0a03d6c7f8acae"
    sha256 cellar: :any_skip_relocation, monterey:       "23ebd53b6f96b4c1114a63b771efdc2e321bdd8d68d2827d2bccffb5c4176572"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad44d062359f8df5be66fb95f351dabe68e3ea3ae319a7ed8a0a03d6c7f8acae"
    sha256 cellar: :any_skip_relocation, catalina:       "ad44d062359f8df5be66fb95f351dabe68e3ea3ae319a7ed8a0a03d6c7f8acae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5f11482bfa10d14b7c9afd10db71aa2183afefceb7525ab1028283a27480db2"
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
