class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.1.4/git-lfs-v3.1.4.tar.gz"
  sha256 "d7bfeb6f4c219c44773da4f93da28eb1e2e654efa4cd23294d9039247d8cde64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f7742c44c6c29b1f991d0e7d5235c4e3923d485ab5aff0b1e35838eb4d48c42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "846be683762d3261e4a923d2af7e4c0e674575e1ef6273daee45bd6d53053aec"
    sha256 cellar: :any_skip_relocation, monterey:       "76c39efa2728041e71808e09a9ea19a73a9b605b0e06a5c421038c1cdc9464a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f9e7d1b3ffc4419fe6310e54ee46a317cbb04938cfb4e8c3f4d692d1c704403"
    sha256 cellar: :any_skip_relocation, catalina:       "df33578be645c8c64ac6ea806a0b2220559a7169b896708708eb26df339a4601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56f2f3065b36a170b567797a8eff3485938e4c45cfb8d367aac9c39a899a41ad"
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
