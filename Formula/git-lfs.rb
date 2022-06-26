class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.2.0/git-lfs-v3.2.0.tar.gz"
  sha256 "f8e6bbe043b97db8a5c16da7289e149a3fed9f4d4f11cffcc6e517c7870cd9e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a81d5b29d1c0203f592e8af7b25ccb95431489ffa8dc595dbb1c39f1c08cfb46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f10c03ed48c4168d8b80164d053040452e772c978344cc485e386183de7d5c24"
    sha256 cellar: :any_skip_relocation, monterey:       "2ccd239da97286fa2f9702f7c2731202819a6012163906b7e599e8fb218a6c95"
    sha256 cellar: :any_skip_relocation, big_sur:        "21c75c877159acff82ada003baa3ea7d65e2774a2636f740e4cfad4ae9d2d7b5"
    sha256 cellar: :any_skip_relocation, catalina:       "c428d687c3a70defa9178fd0b287cd8766f05bf113eb6ae8ce7bcb7940751b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43e16ee02644936dbf6d2d504b8c66cd3e0c3dd1313436e9bd253c4c051e437c"
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
