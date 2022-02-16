class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.1.2/git-lfs-v3.1.2.tar.gz"
  sha256 "5c9bc449068d0104ea124c25f596af16da85e7b5bf256bc544d8ce5f4fe231f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7147e21ff6c086bc90ece19b9dad1add6a91267e9233eff034308e4ffd3c9f34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3aaa1c15a3cf3c518303b7b87e56236c277b6c41d7b8d2bbcfd0d65c6eaa6cbb"
    sha256 cellar: :any_skip_relocation, monterey:       "4c44391922fbb7eb87d99789ae441633593576b624da68b83ac72f0bafd88c00"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5e2d3fbf079c66e4efffd9934454fb16c64cddd60f63cd545886c94e4cd2961"
    sha256 cellar: :any_skip_relocation, catalina:       "8685ece5029a27fcd843cf215f6582ddf4daaf2d7d318ea3cbc441777f8b34cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2f9ebbce14aa9cd511a7379928bd00b5ebf99d8fdd370e080dcc0c6a67fd696"
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
