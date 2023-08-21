class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v11.0.1.tar.gz"
  sha256 "6c1d4dd6cead50b1981dd224bc3face887594da975992b2c6c3748dbdb7efc10"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7769c7e853da8fd246b049a7d6a1623d87a0ef8cce01ae508f43f07fa06b13f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7769c7e853da8fd246b049a7d6a1623d87a0ef8cce01ae508f43f07fa06b13f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7769c7e853da8fd246b049a7d6a1623d87a0ef8cce01ae508f43f07fa06b13f"
    sha256 cellar: :any_skip_relocation, ventura:        "d7769c7e853da8fd246b049a7d6a1623d87a0ef8cce01ae508f43f07fa06b13f"
    sha256 cellar: :any_skip_relocation, monterey:       "d7769c7e853da8fd246b049a7d6a1623d87a0ef8cce01ae508f43f07fa06b13f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7769c7e853da8fd246b049a7d6a1623d87a0ef8cce01ae508f43f07fa06b13f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "413eeafc25905a5231ba97d73a72fd49a177d2214c7f5b91b02f8d179be7431b"
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
