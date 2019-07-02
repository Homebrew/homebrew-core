class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.2.tar.gz"
  sha256 "e88ef4e55a06a7cb770c26f679c6f7c182f7986611cbfede1215c42e34f7031c"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9c5be58e2f01142e7161b42274e9e71c3d11abb4bb51b55d30a3ed78abd71c8" => :mojave
    sha256 "850ccdd7ac691bcaeabeeb2095005086ff8328229ca55ac17fff018b895d5088" => :high_sierra
    sha256 "6d993a4b947aee4ce6770d4b0eebe2529ee112e5cc4bdbecf5e02a4b73956f01" => :sierra
  end

  depends_on "mercurial"
  uses_from_macos "curl"

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
