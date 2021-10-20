class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.0.1/git-lfs-v3.0.1.tar.gz"
  sha256 "ea47feff8cf10855393dd20f22a7168c462043c7a654a5fd0546af0a9d28a3a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c56456eead555df877006db88e09d58f7a9019667cc86927e28291d793b0b379"
    sha256 cellar: :any_skip_relocation, big_sur:       "9776a078dc6a3021b5acb93c1f830f4758044aa5b512b193020870b73f3ad77f"
    sha256 cellar: :any_skip_relocation, catalina:      "51210900180383e69ac3c1f416b11eb0cddf0341995ed02c1f760398fae20f68"
    sha256 cellar: :any_skip_relocation, mojave:        "f70126dde7a1e5c1350c48aab9f96ccee61217de0667066cfb8eaefd249ae968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07f5528e945e60d3c32133daff143dafe964761f3d89d0df47b60bcf459b47b3"
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
