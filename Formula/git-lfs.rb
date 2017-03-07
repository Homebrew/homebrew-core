class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.0.1.tar.gz"
  sha256 "62887214d90f0c1d1ba3da45112dffcc1d6bd1d1fabc9ef1e1ab85341242b11f"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fa5c6b0cbe43d078b27ad31f7be3af8a06bec3d0d449ac2b6b85e061c37e1ea" => :sierra
    sha256 "d36a97f6a0ce4cb42e7bc21597d4f08e9f6930665312620513dfbc571634b446" => :el_capitan
    sha256 "4b6d71c16e670ef503f50798b23d08c812e53eca2fc67759d1d407fb5793e73c" => :yosemite
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
