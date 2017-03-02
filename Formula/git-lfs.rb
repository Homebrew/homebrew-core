class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.0.0.tar.gz"
  sha256 "64597dc8c5460b22ec957b1d0fabec58abcd6f373b9473e419a74f8dff5c508b"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe10ba8e54c8cb528ee04ca21efbda52d84e7bf38b09378332af4088f22c7ce4" => :sierra
    sha256 "16948e15733b56c6d46fd49c72221d590cf56f5557fb486a232412e9d26f008c" => :el_capitan
    sha256 "f8d1e65857216ae490c06ac0fec62ed17c703a52cb8be3d4ff8ccdbb8fd4d94f" => :yosemite
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
