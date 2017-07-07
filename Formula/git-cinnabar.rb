class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar.git",
      :tag => "0.4.0",
      :revision => "6d374888ff0287517084c0ec7573963961f6acec"
  head "https://github.com/glandium/git-cinnabar.git"

  devel do
    url "https://github.com/glandium/git-cinnabar.git",
        :tag => "0.5.0b1",
        :revision => "f4ce4ab5ae70c11f00fbc0964e1edf4da6fe7657"
    version "0.5.0b1"
  end

  depends_on :hg

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
