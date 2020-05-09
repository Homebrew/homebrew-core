class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.11.0/git-lfs-v2.11.0.tar.gz"
  sha256 "8183c4cbef8cf9c2e86b0c0a9822451e2df272f89ceb357c498bfdf0ff1b36c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fec7d8b8ad7c3332bfa1862dd8615712dab8315a9128ed8b5609fa1659431e7" => :catalina
    sha256 "3c5bcef656ca742c6697b952c9f7c483c1fad046f52136dbe9ee0f16f44835c4" => :mojave
    sha256 "ed0d8f1271d9d81a2c22622023c260ef040f2172e75357893ef54134bc6eedff" => :high_sierra
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
