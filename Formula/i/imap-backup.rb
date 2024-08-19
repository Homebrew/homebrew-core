class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v15.0.2.tar.gz"
  sha256 "62d738d5d79d62e884bbd1ebac0cff5233c62e5a98a64f6a1d0f29a3c6e28ab2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66f4eb368585b504742a93f0db630e5c19e3368c87a5e3d4cbfe0d5b4ebb6698"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66f4eb368585b504742a93f0db630e5c19e3368c87a5e3d4cbfe0d5b4ebb6698"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66f4eb368585b504742a93f0db630e5c19e3368c87a5e3d4cbfe0d5b4ebb6698"
    sha256 cellar: :any_skip_relocation, sonoma:         "66f4eb368585b504742a93f0db630e5c19e3368c87a5e3d4cbfe0d5b4ebb6698"
    sha256 cellar: :any_skip_relocation, ventura:        "66f4eb368585b504742a93f0db630e5c19e3368c87a5e3d4cbfe0d5b4ebb6698"
    sha256 cellar: :any_skip_relocation, monterey:       "66f4eb368585b504742a93f0db630e5c19e3368c87a5e3d4cbfe0d5b4ebb6698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94be27d271e5af4ef65a7f5c773333dfb5046688c14f2d424482cc46c9948e32"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Choose an action:", pipe_output(bin/"imap-backup setup", "3\n")
    assert_match version.to_s, shell_output("#{bin}/imap-backup version")
  end
end
