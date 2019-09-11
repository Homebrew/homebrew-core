class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.8.0/git-lfs-v2.8.0.tar.gz"
  sha256 "3347bbe6055b38902e4ef65d0f0aa00b3f100b2ad67a43aee6f340e4eb731535"

  bottle do
    cellar :any_skip_relocation
    sha256 "1dfa249482bce6cdbfc46d6d34e88afd4fc7947dd98d4072b5c6c8909a31b03c" => :mojave
    sha256 "1ea60ee3dffe2ce7af00768361dbd4b2783d2159b7b269960d8504b0ab05c3a6" => :high_sierra
    sha256 "5f4a9d27c5d73aea0c8cb4ed403e15df4885d7aac44fec4d3fee1a82779c6a05" => :sierra
  end

  depends_on "go" => :build
  uses_from_macos "ruby"

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
