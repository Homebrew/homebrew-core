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
    sha256 "8f366361f486082b1f4cd2defa48af5efd1942dd8b848dc66d0560787fd06fbe" => :high_sierra
    sha256 "03f64128f2ec4fb5f0597157c90db69e273cfa1ed521aa928c700b9de1f176d4" => :sierra
    sha256 "5942ec7cbd204c8e6e691b48c38333f0e7cea11cd2a80714fe3952a1f14507e9" => :el_capitan
    sha256 "3f5f4a461ab56361b323f2a934704652011c8a4ada7da719c957005ced268f67" => :yosemite
  end

  devel do
    url "https://github.com/glandium/git-cinnabar.git",
        :tag => "0.5.0b1",
        :revision => "f4ce4ab5ae70c11f00fbc0964e1edf4da6fe7657"
    version "0.5.0b1"

    # same as in stable
    patch do
      url "https://github.com/glandium/git-cinnabar/commit/7ea77b0.patch?full_index=1"
      sha256 "e28fdf1b9afa94dbd17289e739cd68af34bf7ae708b827cfa9e23286dbbbb57c"
    end

    # same as in stable
    patch do
      url "https://github.com/glandium/git-cinnabar/commit/5c59ae1.patch?full_index=1"
      sha256 "263c13fb9a59ed790957fcf337671b093e0b4d434c37b69cf1d0e03fd2a4102b"
    end
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
