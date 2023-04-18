class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v9.2.0.tar.gz"
  sha256 "53ee714bb7a80202fee4e9aaf401a631f12dc5a36eb4585add9ad7bd60450b46"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f148999d378899141b07be539e32dcdbc1af1f6051dd3be674f60a387bec8d29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f148999d378899141b07be539e32dcdbc1af1f6051dd3be674f60a387bec8d29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f148999d378899141b07be539e32dcdbc1af1f6051dd3be674f60a387bec8d29"
    sha256 cellar: :any_skip_relocation, ventura:        "f148999d378899141b07be539e32dcdbc1af1f6051dd3be674f60a387bec8d29"
    sha256 cellar: :any_skip_relocation, monterey:       "f148999d378899141b07be539e32dcdbc1af1f6051dd3be674f60a387bec8d29"
    sha256 cellar: :any_skip_relocation, big_sur:        "f148999d378899141b07be539e32dcdbc1af1f6051dd3be674f60a387bec8d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f3eef8180851df603b4241ee249cf67481952085aa101c77788e00b5ddfd419"
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
