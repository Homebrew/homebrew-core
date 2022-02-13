class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "beafe9510d0c810dece237f6bb7cbba896835ea3a38fbdc36e74c895fcffcbcb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "705a6a2103a1f50808e9f36bbda458bfeed7c136930269e04538a3b87e9586d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11f34662012d0ff244b1823cafad3ed0cbf7fb6f9abc87311bc67149894ffd3a"
    sha256 cellar: :any_skip_relocation, monterey:       "705a6a2103a1f50808e9f36bbda458bfeed7c136930269e04538a3b87e9586d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "11f34662012d0ff244b1823cafad3ed0cbf7fb6f9abc87311bc67149894ffd3a"
    sha256 cellar: :any_skip_relocation, catalina:       "11f34662012d0ff244b1823cafad3ed0cbf7fb6f9abc87311bc67149894ffd3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ec59a5f78a55f047874112c617458bba342c59fe16ce45be36e3754429b2640"
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
