class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v1.5.5.tar.gz"
  sha256 "9f79bb8d5e29155ceabb4c5044df30a6759a97dba23f4121637f4c357a4abb23"

  bottle do
    sha256 "ee6db42174fdc572d743e0142818b542291ca2e6ea3c20ff6a47686589cdc274" => :sierra
    sha256 "e079a92a6156e2c87c59a59887d0ae0b6450d6f3a9c1fe14838b6bc657faefaa" => :el_capitan
    sha256 "c334f91d5809d2be3982f511a3dfe9a887ef911b88b25f870558d5c7e18a15ad" => :yosemite
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
