class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v9.1.1.tar.gz"
  sha256 "ee1a8bcc891df92ed8a7d0e55e7d966ae358bd9a935429fbfe993dca8d887229"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67b34da3291c029b76ffc50dde6e9294ac5ba735be80978e7b68f2f887ca4e3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67b34da3291c029b76ffc50dde6e9294ac5ba735be80978e7b68f2f887ca4e3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67b34da3291c029b76ffc50dde6e9294ac5ba735be80978e7b68f2f887ca4e3a"
    sha256 cellar: :any_skip_relocation, ventura:        "67b34da3291c029b76ffc50dde6e9294ac5ba735be80978e7b68f2f887ca4e3a"
    sha256 cellar: :any_skip_relocation, monterey:       "67b34da3291c029b76ffc50dde6e9294ac5ba735be80978e7b68f2f887ca4e3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "67b34da3291c029b76ffc50dde6e9294ac5ba735be80978e7b68f2f887ca4e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73685dda4b18138439e853acbfd20871fee2187375cc88c4b520cae86f2340f2"
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
