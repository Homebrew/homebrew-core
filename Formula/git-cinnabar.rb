class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.7.tar.gz"
  sha256 "1f30b79b89b421ba33e47f00a8301da5b7533e10cc6314c4febd23ad6ed4b17b"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "007e72fecc77d272780e7bdfa285851ff54151ab52056db1005d3e6fdc0ef645"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b626b0efd0fa40519709c9611ac32134adbe6bbe83ca9ac4068a2f8ce5babc6"
    sha256 cellar: :any_skip_relocation, monterey:       "c879947d92e38d6751b7506b0f0cc5e4e468caab42f8cd9d64ae786239f78708"
    sha256 cellar: :any_skip_relocation, big_sur:        "68a335fc1ed34f8207dc50a1772424d25c3f670e8a6ee643d6ac31e95dd7df61"
    sha256 cellar: :any_skip_relocation, catalina:       "d9b9bdf7c8c135a469842f62b8d95ab68d7135cd3bab11bf350eacc70b9ccd51"
    sha256 cellar: :any_skip_relocation, mojave:         "c137a58d44bcdc96eac89581334411fe95e5eb98824b558ee4249c30bef9aa67"
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
