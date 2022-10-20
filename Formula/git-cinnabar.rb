class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.10.tar.gz"
  sha256 "20792358201417fa64cb3b1b9ccd6753909f081b0bf11cb9908f55a3607627e1"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45c4131d5e6f2334043600361bcbadc35a958f0af1622911bcfa7e6630feb1c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fae6f93aeabe58a4f42ed4cdad391eef193b86b4cc52dd355d00a16a7a0583d1"
    sha256 cellar: :any_skip_relocation, monterey:       "ad041f42520a697f1b3e540370dcb76add2436c77b893e349dbb51378c2fdaba"
    sha256 cellar: :any_skip_relocation, big_sur:        "292c8b28e12de0559e3dced8386aac27696de6bca127e11b9c0733b387f3fd13"
    sha256 cellar: :any_skip_relocation, catalina:       "a66c188e82bda40b4457fb0da18fec6559350b4c6dab168f1f8f5b4029ebcc04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35415f00c4cd5caafc3f325893d2b7c2af7e1d3004cc9e758f031173979ea586"
  end

  depends_on "mercurial"
  depends_on "python@3.10"

  uses_from_macos "curl"

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, PYTHONPATH:          prefix,
                                      GIT_CINNABAR_PYTHON: which("python3.10"))
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
