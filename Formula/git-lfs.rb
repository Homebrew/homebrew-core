class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.2.1.tar.gz"
  sha256 "a55daef5a95d75f64d44737076b7f7fd4873ab59f08feb55b412960e98da73ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "7abfe861bf3befb9d05cf2541e72bcb5d863667c572cf9c92f514d7a3e5cade7" => :el_capitan
    sha256 "45bfe327ece7a965ec6116e0f54b3a41923dbf2dd61975d5a17af3a55cd0841d" => :yosemite
    sha256 "fcfbeb760e5aed5d4a635899be8798c90a83cf6fab8c822175be18087850112c" => :mavericks
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
