class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.9.2/git-lfs-v2.9.2.tar.gz"
  sha256 "77358e12545415a6716b1e0228540f0e90619f1738dfe114cd3e5c30d43ffffd"

  bottle do
    cellar :any_skip_relocation
    sha256 "584207acb926949f5c093d87d06e3e9deda2c78640041120d431f17bb5dad4c3" => :mojave
    sha256 "b24483f15a987597f2b905b40882f3f89c69e478c01c434310d16c1145b161dd" => :high_sierra
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

  def caveats; <<~EOS
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
