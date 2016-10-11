class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.4.2.tar.gz"
  sha256 "3bba0679a7d8b8684011b43a33c9d1571e7d07ba84965ebf50da554f10cedf98"

  bottle do
    cellar :any_skip_relocation
    sha256 "676ae40ff5796b63af2ce7bb435ed4688d348bc8502af08fb75b7aa57ac9124f" => :sierra
    sha256 "f6aaf875570645e41d33928ceb1ecb547858b580725582b6f9a3f068f7875438" => :el_capitan
    sha256 "460ec77e88ea26a0d09805fcfa55a9cf5fdba072ba0f4e89d99204bc254b272f" => :yosemite
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
