class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.6.tar.gz"
  sha256 "64c483e93eea5ec9ef142988e272f949428db2ef685aecc31ce112e24f55f3c9"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5a93076b2e9594362fa665edf9aab87ad5f6861a179ec2e16fb87241caf135d" => :big_sur
    sha256 "1944a8e26196b0c068235d412a08abe53e8e8ef9e7fec9e6c3e18ad73837301d" => :arm64_big_sur
    sha256 "074ae846819011d8632aadec2f3532dd2c1bf8c36385f09b09b7d8d977c3f411" => :catalina
    sha256 "049b1d43555be25052dd9857fbdb35a871daf0c4b25b23568d881bac4e69aa75" => :mojave
    sha256 "ab04140cfeea3a7c0370aae72b4b0ebf98bb5c6b72aaf1fc02cd9cdf7eb3ecce" => :high_sierra
  end

  depends_on :macos # Due to Python 2
  depends_on "mercurial"

  uses_from_macos "curl"

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, PYTHONPATH: prefix)
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
