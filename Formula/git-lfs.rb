class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.13.3/git-lfs-v2.13.3.tar.gz"
  sha256 "f8bd7a06e61e47417eb54c3a0db809ea864a9322629b5544b78661edab17b950"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5cb96b8109d4a8bcc43469b6d8d6a5bfe57346dcbb2c70dec0491870a37d7cec"
    sha256 cellar: :any_skip_relocation, big_sur:       "8515eb49b4b28ba9297e6a7dbecdda0a81f7b58addc83b939b369c8114dc5529"
    sha256 cellar: :any_skip_relocation, catalina:      "6270f8027d8e1edbd9c0742a7e35fdcaafce8a606241f0176519bdee78b2e955"
    sha256 cellar: :any_skip_relocation, mojave:        "ecccceff1d45c2966f308246b76a4cb67ca4ccb3cf7ccbb73a3b12ae5c1ec246"
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
