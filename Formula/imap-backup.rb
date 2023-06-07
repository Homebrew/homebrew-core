class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v9.3.1.tar.gz"
  sha256 "64785003142d6a52be15c6cbc9ed93c89a27435821f3352b8ffc0cbb96c63f09"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "585b6f09adc5c5576e18b6910e84c8c761c7b74d96ea7ca3cb0be7067fac1541"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "585b6f09adc5c5576e18b6910e84c8c761c7b74d96ea7ca3cb0be7067fac1541"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e29730772025aa851baeeb11bcfa997a2aa43b8d5cfa074c95756952277e1daa"
    sha256 cellar: :any_skip_relocation, ventura:        "585b6f09adc5c5576e18b6910e84c8c761c7b74d96ea7ca3cb0be7067fac1541"
    sha256 cellar: :any_skip_relocation, monterey:       "585b6f09adc5c5576e18b6910e84c8c761c7b74d96ea7ca3cb0be7067fac1541"
    sha256 cellar: :any_skip_relocation, big_sur:        "585b6f09adc5c5576e18b6910e84c8c761c7b74d96ea7ca3cb0be7067fac1541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "239640d0db38c7a86d161ae1cfe0783d84a34c07fdfde79f0548c50d0c1a9ace"
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
