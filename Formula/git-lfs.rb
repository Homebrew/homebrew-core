class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.7.0/git-lfs-v2.7.0.tar.gz"
  sha256 "245737f6fb2fc3476954329531042f6da1823b86bc13a0b32935bd3bb4ad5397"

  bottle do
    cellar :any_skip_relocation
    sha256 "527998277c96a0074ccd2fe56f372804450bf1b3cb0771b923096316d95b0924" => :mojave
    sha256 "e39cbb3628b9b750a5a14405a2dcaadd09a95b52f72a1f6aa47f93fd53562d14" => :high_sierra
    sha256 "4224f5244cc9c665d07596790b6fbe27462db03cbf6e00b2435f47400ae9258c" => :sierra
  end

  depends_on "go" => :build

  # System Ruby uses old TLS versions no longer supported by RubyGems.
  depends_on "ruby" => :build if MacOS.version <= :sierra

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
