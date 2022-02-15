class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.1.1/git-lfs-v3.1.1.tar.gz"
  sha256 "668147fabf314d32b86ff1fe921155cd899621b24eed212bf4a3a80e440eb8db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "003941719623f2b66e8304a33c822f5f641ef7d60ae0a0e73908a0fe94cd4033"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c446f108807f122d8fc2bda50db508b0d6cd30fbac838907c1e93a1841e64911"
    sha256 cellar: :any_skip_relocation, monterey:       "cf18fec26566a927a07e6296c5ba017c45ba06c1ccd42c8a3f3081335040ddd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8badc22ff338d2b9586044ee0758981fca60b960da1c511ea3e0fc9f79a3856"
    sha256 cellar: :any_skip_relocation, catalina:       "c1685e20dda8b14c40037e57642591fef5ce2b450c2e4d7cc44509b5d134bb13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91ec5f2f61ef6a819347d93c46048987d5bb285d040352bff475fb698e6876af"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "ruby" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    (buildpath/"src/github.com/git-lfs/git-lfs").install buildpath.children
    cd "src/github.com/git-lfs/git-lfs" do
      system "make", "vendor"
      system "make"
      system "make", "man", "RONN=#{Formula["ronn"].bin}/ronn"

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
