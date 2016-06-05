class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.2.1.tar.gz"
  sha256 "a55daef5a95d75f64d44737076b7f7fd4873ab59f08feb55b412960e98da73ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ce4e36ed803d7ee2863b8a84b2123fb29f34e02e7c2f908284bb24408f94a65" => :el_capitan
    sha256 "4994740a50e283133ccc73432e1e642ed676268bd9854a0632f96c6c08bf4dea" => :yosemite
    sha256 "fb598e03d6360c6850acdbbc29e05dcf6ca3d33e14d112efdb3e92bd5e543e25" => :mavericks
  end

  depends_on "go" => :build

  def install
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
