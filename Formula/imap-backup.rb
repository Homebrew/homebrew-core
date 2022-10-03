class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "02b1fa9752c0211490f6289e160d575fe7c3c5c00f1860256f4f75b2a5c320e9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "916d69b59bfc92f21b4747e2417ae3b585f2462c992110d1ae87c7180b4771bb"
    sha256                               arm64_big_sur:  "1359a44ad56e9a0d93c98ca7c6c1f05192d5f950de2b7f7cd88e57f7142f2fe9"
    sha256                               monterey:       "ee03f10dd3286bcd2ab7725577636986ffe4225d00ced672885e276bc1f73f09"
    sha256                               big_sur:        "d6975f7bc55e1059c2b2069accdbf32abf79f82639493b2234bee466063c917f"
    sha256                               catalina:       "272a3f6da9cdf7268171338be8d23b23be086cb27670955ef89ecd9820ea8403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f13a41e7fb0655611cb4b3395b672c7cf134a573d7dc4f48d4b7fada8fccf33e"
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
