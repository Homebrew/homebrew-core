class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "758b586d5198ba0e8d987ee513dcbd13c6205bd05b4e32c49e064288de4b35f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14e54c1dd3875213132d34a8218088fb1b59221da695dd49fc42481171c472c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bf858915fff9715cced1cc407115e293b3faa9bc4aa500d0ea3ad9cfa342b7d"
    sha256 cellar: :any_skip_relocation, monterey:       "14e54c1dd3875213132d34a8218088fb1b59221da695dd49fc42481171c472c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bf858915fff9715cced1cc407115e293b3faa9bc4aa500d0ea3ad9cfa342b7d"
    sha256 cellar: :any_skip_relocation, catalina:       "1bf858915fff9715cced1cc407115e293b3faa9bc4aa500d0ea3ad9cfa342b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77ea795bca1ae2bec5ddf47040bb225cad6014d38ad666bd4f3bf587f30fcd25"
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
