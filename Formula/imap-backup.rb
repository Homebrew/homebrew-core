class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "beafe9510d0c810dece237f6bb7cbba896835ea3a38fbdc36e74c895fcffcbcb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4bbe3f5e0073372a6057a7d1d4e8487b0f5ff81e99b4092ee58fd9abaa929b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26ec682f32047134c40880b470725cc6a33e0c020b918d02445e0a5f488f3e00"
    sha256 cellar: :any_skip_relocation, monterey:       "f4bbe3f5e0073372a6057a7d1d4e8487b0f5ff81e99b4092ee58fd9abaa929b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "26ec682f32047134c40880b470725cc6a33e0c020b918d02445e0a5f488f3e00"
    sha256 cellar: :any_skip_relocation, catalina:       "26ec682f32047134c40880b470725cc6a33e0c020b918d02445e0a5f488f3e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5715f3f4efb6677551f7562bda3b95bb450bc4311dfaecf74ba39112630056f"
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
