class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.6.0.tar.gz"
  sha256 "e75b361d828d7b6e9ba537137d5243fa1e000a20686cddec2775b533a6b08f01"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbe2d1a7a645d81f76daca4599bc2136e0c23924cfe50f579b6563821d69aa27" => :mojave
    sha256 "577f94bb93b07ca1fe6c0ed26d03a7ad485c6d363281640f3677fc9919314dc9" => :high_sierra
    sha256 "57cab08034d61a6393adcd2167868c8682a049092b8d04843c7513a670063ab5" => :sierra
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

      # Git LFS v2.6.0 removes dependencies that are necessary in order to
      # install it. Set RM=true for now to make removing those dependencies a
      # no-op.
      system "make", "vendor", "RM=true"
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
