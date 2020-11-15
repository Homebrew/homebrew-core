class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.6.tar.gz"
  sha256 "64c483e93eea5ec9ef142988e272f949428db2ef685aecc31ce112e24f55f3c9"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63fcc4e7b3080280b06da11e5c86f17d5f120984ea104f9983f4e9b4a12ba9bc" => :catalina
    sha256 "384bddafdfea606547c363e9f53a0ddf97ccd5a407077c3200019e43e8d4853e" => :mojave
    sha256 "8db1f3570d953a49235634aac491322fd68132c036b959fb9c5ff6960f1b4b58" => :high_sierra
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
