class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.8.tar.gz"
  sha256 "7971c2ae17d2b919f915efab35e3aba583b951d53ca2bc6ebf69bbd0c22f1067"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19ed5d8d7c8a59fe542ed94aa565a8d134aedb3d10936ed6a797516ee8e6f315"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a2415da3841ac338a70dd500083dddf4eafd210b3bf8be37dbb4a87d49beb0d"
    sha256 cellar: :any_skip_relocation, monterey:       "b85500153d25ede5b84757cabed62051049083ebce4736b6b3d2d37c70a13fa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f6a6716f169369b40161c8a2abe5efd68de5bf67a789cf15049389ce3d3f2be"
    sha256 cellar: :any_skip_relocation, catalina:       "29f41d5d2c312a84893e3d4d284dd3d72a8d518b512c5caebb1c19a6bad980b7"
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
