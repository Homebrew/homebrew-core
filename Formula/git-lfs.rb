class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.0.2/git-lfs-v3.0.2.tar.gz"
  sha256 "7179a357a0d0e7beaba217489f7f784ca8717035a5e3f1ee91ca7193ba3a35f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c29212adc03440123d3732cecc321bdf8e7e946ee13580e00882c8f2e415c567"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "064d030a26d7928685602c3fbd6daeb30e4d81b3a94f86aa3ddd2ffe1bd8396c"
    sha256 cellar: :any_skip_relocation, monterey:       "79dc4e28ac75d8ee526215b10c16d17873009a9cb8fcfd50c92069868a01e2ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2cac31dfa6ded45a6633c730816551bd3e4810a2b7fe3cdc414a830a02e7c10"
    sha256 cellar: :any_skip_relocation, catalina:       "6f86300bf487d24aace589b4c78521b6dce3f834e660b926d81dd28544d561e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c8824cdcda78651cfd106352af9ae9834b8c4996081a9cb35f564afd1139689"
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
