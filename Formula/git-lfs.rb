class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.5.0.tar.gz"
  sha256 "a09304d8bc767643469d738d3a1defbe5b3627dd4777bc668517a6a4f6018373"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce479c1e882e71424b31f99712df288fbf77935f85d27f9f0cdbbdedc774dc92" => :high_sierra
    sha256 "83fb6dce04da20d262d966b54b256471779afeccc0c17d3171d14a8442255477" => :sierra
    sha256 "845e5877f4d1beb7ad15a7b9a078b4d820ff1f8392827ec42c8cbf7fd48850ba" => :el_capitan
  end

  depends_on "go" => :build

  # System Ruby uses old TLS versions no longer supported by RubyGems.
  depends_on "ruby" => :build if MacOS.version <= :sierra

  def install
    ENV["GOPATH"] = buildpath
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    (buildpath/"src/github.com/git-lfs/git-lfs").install buildpath.children
    cd "src/github.com/git-lfs/git-lfs" do
      ENV["GEM_HOME"] = ".gem_home"
      system "gem", "install", "ronn"

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
