class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.13.3/git-lfs-v2.13.3.tar.gz"
  sha256 "f8bd7a06e61e47417eb54c3a0db809ea864a9322629b5544b78661edab17b950"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "def0547e1e83bda58b68b6880f3eb5a0a803df0addfb6e4915b6b76852735195"
    sha256 cellar: :any_skip_relocation, big_sur:       "db355632f3236b7042d2900b7883edfe476d9fb467e62124bb5864ab2be88415"
    sha256 cellar: :any_skip_relocation, catalina:      "b4c1b5d14562c7a1e0fbe210dc5e58888dff8437586ffc49425099c546a988b0"
    sha256 cellar: :any_skip_relocation, mojave:        "0aaead90f98027ec8774eb318a58c6f5bef167342a52b115207ecb878f63e7f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "918e279cead08a4d34efccd29eb656849b727c46b4431287b326e8f0fe92f40b"
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
