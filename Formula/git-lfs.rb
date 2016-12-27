class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v1.5.4.tar.gz"
  sha256 "4dc539f54ac51dc3d22ac7eb5991bd61533dcd717ab462e125417266553bf88a"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7aa87a5d87d83fe484a01bbec51e5ccba7b83d076321bdabf1fee107f38c1a6" => :sierra
    sha256 "d8b28b3dd372039f37776eb8cef157bb1d344a732e8de96bd8be1bffcc2bb2bc" => :el_capitan
    sha256 "d28eed1186dc4702eb42d8a31129fd1d523eb084a9376552241bd152d05a274d" => :yosemite
  end

  depends_on "go" => :build

  def install
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  def caveats; <<-EOS.undent
    Update your git config to finish installation:

      # Update global git config
      $ git lfs install

      # Update system git config
      $ git lfs install --system
    EOS
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
