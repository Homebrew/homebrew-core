class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "fb52fa67ffa6cae2452777f056c6930b194610b9ffc75d04d0b1db8de5e79d19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e7bdf9e057c44da29d990ed2eeabe466f7519b25965724eb21c06aa4328c8d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3057cd7a3636a5cc7de552bc4ba7cba23cfa157ca9cd9674ce17657de37c0eb6"
    sha256 cellar: :any_skip_relocation, monterey:       "9e7bdf9e057c44da29d990ed2eeabe466f7519b25965724eb21c06aa4328c8d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3057cd7a3636a5cc7de552bc4ba7cba23cfa157ca9cd9674ce17657de37c0eb6"
    sha256 cellar: :any_skip_relocation, catalina:       "3057cd7a3636a5cc7de552bc4ba7cba23cfa157ca9cd9674ce17657de37c0eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27915190ca7ee931bc7d46fb8ae0227eb286790e6d4c8e48f55390c7892699f6"
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
