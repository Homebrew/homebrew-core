class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.4.4.tar.gz"
  sha256 "ee4c3b459dd08cc9443fc5774baf342abc9b7975ffffbefb52b248b3eb91dd33"

  bottle do
    cellar :any_skip_relocation
    sha256 "9525671f9e3610c263a369ef5bbdd6d194fe4cb2175628a75578db9d86e0e637" => :sierra
    sha256 "b415b7740fc7d6fa6f2a73fe716edb7f81619bde0dbb23d7e896f8dd37ae053b" => :el_capitan
    sha256 "95ff6e7a732b661d031db1418cc2121655e0ca9ce2394c7c9334fdddf5c79b3f" => :yosemite
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
