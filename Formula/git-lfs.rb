class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.5.1.tar.gz"
  sha256 "85c3148c7cbd9216e356b9317bc726ff8d982b37654ec1b26c537238ba9bfd8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "15333ffc32711c11d739fbcde3785ef0243ed7ac65d69b9614c418842978dd5f" => :high_sierra
    sha256 "8fa77cbd43541a3284ded867fc7c995e321dde13ec1c8358ae25f311590108e5" => :sierra
    sha256 "329e996f4ced5247b258f5375d7b0a43a5bb91086b1d81315eb4ee6f1dd70070" => :el_capitan
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
