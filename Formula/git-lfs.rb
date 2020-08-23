class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.11.0/git-lfs-v2.11.0.tar.gz"
  sha256 "8183c4cbef8cf9c2e86b0c0a9822451e2df272f89ceb357c498bfdf0ff1b36c7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "351d2d6cb168249b9b7b0d55628574126b9787eab1441861dfd324b952057651" => :catalina
    sha256 "adbf311076f64920e0f621640d251e6ef44ad8fc9022f287118be5644c4095d4" => :mojave
    sha256 "0c231fb0f6edab306f9b58f08fb8c075860f688d6efe4190b6377c661e36d18c" => :high_sierra
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
