class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.13.2/git-lfs-v2.13.2.tar.gz"
  sha256 "782e6275df9ca370730945112e16a0b8c64b9819f0b61fae52ba1ebbc8dce2d5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebc56da970278c2f7fd44a73d855c8bdbbb27ecb3526b0e44e59124301300b0b" => :big_sur
    sha256 "8187fc30c663ba60b09ade690c90fcf4e842050ba7f72969c53c46a03f29a17e" => :arm64_big_sur
    sha256 "069c9abf9aae2690f9f30ddea080d21aeb78e8cecbceee843d8eefe6e2248551" => :catalina
    sha256 "a9d3e9326f96e0684eaed9fd9fd992dd9ad9f8e1ff01630d9c73ababe72b654f" => :mojave
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
