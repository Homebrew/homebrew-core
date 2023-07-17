class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v10.0.1.tar.gz"
  sha256 "bbfcfdc8ad72f666175154ac7ff3c52ecb3779efe8d438756bc0d48a5b7312b4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "795b4c27f0bac0380b12be43092ffd85018177edf5712c1e33a70d7cbc2c8559"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "795b4c27f0bac0380b12be43092ffd85018177edf5712c1e33a70d7cbc2c8559"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "795b4c27f0bac0380b12be43092ffd85018177edf5712c1e33a70d7cbc2c8559"
    sha256 cellar: :any_skip_relocation, ventura:        "795b4c27f0bac0380b12be43092ffd85018177edf5712c1e33a70d7cbc2c8559"
    sha256 cellar: :any_skip_relocation, monterey:       "795b4c27f0bac0380b12be43092ffd85018177edf5712c1e33a70d7cbc2c8559"
    sha256 cellar: :any_skip_relocation, big_sur:        "795b4c27f0bac0380b12be43092ffd85018177edf5712c1e33a70d7cbc2c8559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58508bf77535e8dd69bc896f009a1352661b9e2b52caa40f976653e0550e9e1e"
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
    assert_match "Choose an action:", pipe_output(bin/"imap-backup setup", "2\n")
    assert_match version.to_s, shell_output("#{bin}/imap-backup version")
  end
end
