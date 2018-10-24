class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  revision 1
  head "https://github.com/glandium/git-cinnabar.git"

  stable do
    url "https://github.com/glandium/git-cinnabar.git",
        :tag => "0.4.0",
        :revision => "6d374888ff0287517084c0ec7573963961f6acec"

    # 5 Nov 2017 "Support the batch API change from mercurial 4.4"
    patch do
      url "https://github.com/glandium/git-cinnabar/commit/7ea77b0.patch?full_index=1"
      sha256 "e28fdf1b9afa94dbd17289e739cd68af34bf7ae708b827cfa9e23286dbbbb57c"
    end

    # 5 Nov 2017 "Adapt localpeer to sshpeer changes in mercurial 4.4"
    # Backport of https://github.com/glandium/git-cinnabar/commit/5c59ae1
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e56093e/git-cinnabar/mercurial-4.4-sshpeer.patch"
      sha256 "9af333567ff4aec002c947906d9e5a62ce7358c4ffa1edf7be0b5fe0a96b87ae"
    end
  end

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
