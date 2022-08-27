class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "d9d9d33a67b94474e8b619199a1007ca7dcfee6ef7298781fdb043676d2b0830"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f95d6287d5aedfc62fc83183ec491b2eb0766db5ed10ad090cca9dea1531fdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "365b8d26934f7998b96770f719790d6a512acdef5bc398f5b3d360347ca5fea7"
    sha256 cellar: :any_skip_relocation, monterey:       "1f95d6287d5aedfc62fc83183ec491b2eb0766db5ed10ad090cca9dea1531fdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "365b8d26934f7998b96770f719790d6a512acdef5bc398f5b3d360347ca5fea7"
    sha256 cellar: :any_skip_relocation, catalina:       "365b8d26934f7998b96770f719790d6a512acdef5bc398f5b3d360347ca5fea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191c3525a6150c5c0a75b8060ade9f3bee8ffe7b2c47d00faa99a34a18f01294"
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
