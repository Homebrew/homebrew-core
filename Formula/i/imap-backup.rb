class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v16.6.0.tar.gz"
  sha256 "b224c2a2a2eefb6438f2da4a9954f7ae6d7b876b718f15629824b76e4e021e4d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27032b92ee4a547f2ba88cf4b99934d61a372447eb354e5a3196c753064deb5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27032b92ee4a547f2ba88cf4b99934d61a372447eb354e5a3196c753064deb5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27032b92ee4a547f2ba88cf4b99934d61a372447eb354e5a3196c753064deb5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "afeda25fe9409022479da559e368e397e3e08be45510c490ca50fe1d1893d0cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baae0a0eeba4def6d8ee83f0e413d9135602c128a3a737047146604dc3b33771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f3c38aafbfc5172824709cb2c4f99d7777597dd05eb3c1a3156b2215e62a577"
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Choose an action:", pipe_output("#{bin}/imap-backup setup", "3\n")
    assert_match version.to_s, shell_output("#{bin}/imap-backup version")
  end
end
