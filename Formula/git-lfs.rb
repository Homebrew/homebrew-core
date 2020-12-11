class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.13.1/git-lfs-v2.13.1.tar.gz"
  sha256 "5ba7d945d96ad49492e29edbfd1cce528b2a034fdddbf6e5424e754a4a012029"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d258fd1e12337ddc58f8d9a23af8a631096248471a75bc6c8ae10b3994b9095c" => :big_sur
    sha256 "d179461dff4a07c40e0b54078f56a5e46edcc6966708726a9b17c159981eef35" => :catalina
    sha256 "562551db4c901b4227ab55ceef73d39a01c2227961bf3657975e991898000288" => :mojave
    sha256 "4705b3adb23213242e7df1a27e948b85ba2d8fa5ea15743b4d63482a07ed732e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "ruby" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    (buildpath/"src/github.com/git-lfs/git-lfs").install buildpath.children
    cd "src/github.com/git-lfs/git-lfs" do
      ENV["GEM_HOME"] = ".gem_home"
      system "gem", "install", "ronn"

      system "make", "vendor"
      system "make"
      system "make", "man", "RONN=.gem_home/bin/ronn"

      bin.install "bin/git-lfs"
      man1.install Dir["man/*.1"]
      man5.install Dir["man/*.5"]
      doc.install Dir["man/*.html"]
    end
  end

  def caveats
    <<~EOS
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
