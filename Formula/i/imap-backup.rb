class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v12.1.0.tar.gz"
  sha256 "1595503f559a570a4c1f8293e02f849d8db13a4391131b6bb47c5c6fe9167720"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ffb68cbc53f441e204ab31b1fe39a57166eb6ecd389db19fbc2d031861bff6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ffb68cbc53f441e204ab31b1fe39a57166eb6ecd389db19fbc2d031861bff6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ffb68cbc53f441e204ab31b1fe39a57166eb6ecd389db19fbc2d031861bff6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ffb68cbc53f441e204ab31b1fe39a57166eb6ecd389db19fbc2d031861bff6f"
    sha256 cellar: :any_skip_relocation, ventura:        "1ffb68cbc53f441e204ab31b1fe39a57166eb6ecd389db19fbc2d031861bff6f"
    sha256 cellar: :any_skip_relocation, monterey:       "1ffb68cbc53f441e204ab31b1fe39a57166eb6ecd389db19fbc2d031861bff6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0aa7917eda399c3cdf27560bb304b62e1631d9cf37fa571a4ebd8657e84d243"
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
