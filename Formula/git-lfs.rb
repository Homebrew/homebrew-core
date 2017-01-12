class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v1.5.5.tar.gz"
  sha256 "9f79bb8d5e29155ceabb4c5044df30a6759a97dba23f4121637f4c357a4abb23"

  bottle do
    sha256 "bd66be269cbfe387920651c5f4f4bc01e0793034d08b5975f35f7fdfdb6c61a7" => :sierra
    sha256 "7071cb98f72c73adb30afbe049beaf947fabfeb55e9f03e0db594c568d77d69d" => :el_capitan
    sha256 "c7c0fe2464771bdcfd626fcbda9f55cb003ac1de060c51459366907edd912683" => :yosemite
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
