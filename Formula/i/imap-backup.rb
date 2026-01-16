class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v16.4.1.tar.gz"
  sha256 "ff1649a1083c887e6055c63ab16ec2bd2cef9251231091819653564aa79ccd78"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bad5cee2f71618ebb208877c5e7a13c4365874d8c4e4d309460a00d709a665f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bad5cee2f71618ebb208877c5e7a13c4365874d8c4e4d309460a00d709a665f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bad5cee2f71618ebb208877c5e7a13c4365874d8c4e4d309460a00d709a665f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed3528c4f0bd26c270a1f5e70b6d08b0d1e871420ae34a915dfe64a2d26b7173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68dd9061c6d0ca0cb5d9f636391d5ce2e2507abb7014d74ab2c367bb16a2b68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c5fa1f24cfb97677325fa6320acaae5e30dbb4745dabd594577d5ce126ead1f"
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
