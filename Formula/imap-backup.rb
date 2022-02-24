class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "af247527ab77faa81d76bb4e7dfc530a78d71c2801c4bc825829315aa4eab3db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbfb9588684ff9edbf08ce93bc04e03380c50279167585ab3e81434f0b81301a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cc0e0e09dd4c774cca2b88635d08e570c25cdc6249a6b5b9b731fcda02ade9c"
    sha256 cellar: :any_skip_relocation, monterey:       "fbfb9588684ff9edbf08ce93bc04e03380c50279167585ab3e81434f0b81301a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cc0e0e09dd4c774cca2b88635d08e570c25cdc6249a6b5b9b731fcda02ade9c"
    sha256 cellar: :any_skip_relocation, catalina:       "5cc0e0e09dd4c774cca2b88635d08e570c25cdc6249a6b5b9b731fcda02ade9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ccc122dae09432f7c7fe9d491570632a5406f60484aa182ca3e4d140e0d584"
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
