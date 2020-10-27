class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.12.0/git-lfs-v2.12.0.tar.gz"
  sha256 "9971d91cd2b0dd34ccda41a3db97504bfdb4fbc23cc2ee4b6e3b9afea5643941"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a6198c2a8cc656833215ee963e87536a3849405a560c9a52e50b578144d1142" => :catalina
    sha256 "a407e33c74000f21d71a3b4afdf874404e94c8f282eac7529e81a2da6ff29989" => :mojave
    sha256 "c5b7a9e92dc8783a208bdafbd6d4c2337665b5f3e3379e6d1096b4c928029141" => :high_sierra
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
