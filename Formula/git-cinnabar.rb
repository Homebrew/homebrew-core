class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.0.tar.gz"
  sha256 "1e09c7c24a34eb172681283ca243677ea06f4da179916a907f43f9027ca59dea"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1bc858159849754768cb460e3078c59832f1ace5c91e8491aeaf9338f759c79" => :mojave
    sha256 "30cc00b0406ccca2d8c5e29ca6217cf0ae8cb6925e7607b0fb67385aab973f63" => :high_sierra
    sha256 "fddd63b61e1e4b624bf7e9585f32467915437bbc093588e2e0c6c209b649b5bb" => :sierra
    sha256 "8549a043b40628b7141ed2d58cd8d473bb49345b52e4f6586554d5990770ddd3" => :el_capitan
  end

  depends_on "mercurial"

  conflicts_with "git-remote-hg", :because => "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, :PYTHONPATH => prefix)
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
