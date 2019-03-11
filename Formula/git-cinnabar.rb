class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.0.tar.gz"
  sha256 "1e09c7c24a34eb172681283ca243677ea06f4da179916a907f43f9027ca59dea"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e3f534c222993f479e8e2db49e54b0692deb394d07ea79b52eceee5bbc1ad04" => :mojave
    sha256 "cbd5edcb40be1b5cdf8fb93de3521ba409397e807f575e5a7feeebde40170be1" => :high_sierra
    sha256 "c5a0fc3194a4d481b9429cab610ec7ba5ef849f0b76b8cfcb1c5fe3bc97025db" => :sierra
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
