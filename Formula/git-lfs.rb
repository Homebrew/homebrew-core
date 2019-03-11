class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.7.1/git-lfs-v2.7.1.tar.gz"
  sha256 "0334bea2c917cd8ed1215bca0c3fe8f015f664651611fe410826fe14bdcae0d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "759ac2c2aa483ec14fc41e79ee798dc148c608e8574772316ab228d4dac8837f" => :mojave
    sha256 "7a9732daa19813b37895fe94f4c91d9b47bab837a488da2dc99d1134a4cbedde" => :high_sierra
    sha256 "0a8ae7b598e77655081fe07756e13711331e44bfd01091bf024611bf054c1763" => :sierra
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
