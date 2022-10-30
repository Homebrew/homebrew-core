class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.11.tar.gz"
  sha256 "20f94f6a9b05fff2684e8c5619a1a5703e7d472fd2d0e87b020b20b4190a6338"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19134d0b8e50e6c445e930fe3970d1f7fb127cc7771a52b31a634722cf4fed44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c22ae9625b00a726c61a88c6e59dc53197c5a58474c94f8ba0dd6dad3515f729"
    sha256 cellar: :any_skip_relocation, monterey:       "63406dcc3b360b1b216f35092fa654a16d48605f7b6d0f30330572a9f8dab4ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d012962678db67c789a6f0af6b3301eef3e6bd4b06f082ef6a63463db608c9a"
    sha256 cellar: :any_skip_relocation, catalina:       "2f2e81d73bbacbdc32b6e9c1600da137c93371b85b9f273c43f5b95e52cf0704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5961e71a9cf08e155c1452e380bcba3497f39a784363d87d09c50dda188dc3c"
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
