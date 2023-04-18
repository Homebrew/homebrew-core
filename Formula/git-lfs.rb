class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.github.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.3.0/git-lfs-v3.3.0.tar.gz"
  sha256 "964c200bb7dcd6da44cbf0cfa88575f7e48d26925f8ec86d634d3f83306a0920"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2494e1f9476db089187db2ad87b19f6db6005ad5dad592dcc525325931386f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27330db9c9e56a99ae73549aad8b0175713238e443bbff427ea78d1f55a00cab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d5ee372ff1ea648838d260b7b545adeb2b156005bfb59d001739ce9a93ad66b"
    sha256 cellar: :any_skip_relocation, ventura:        "e5e655f93e3ba8f92b63b39f0eb78f2d3312ac05e583112d7142a30cda4eaa42"
    sha256 cellar: :any_skip_relocation, monterey:       "ae55db055bdc131b491b6b35ea41edeff9d5bde71afda7c06a0374569be78bf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c215057bd7ebb8535d58690798effe6f18ad42f3d2605539627166e40b6a3a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f18741e398a3419f41e4e9a524e4f6044418a14930304fb1048a68852192eae2"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "ruby" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    system "make"
    system "make", "man", "RONN=#{Formula["ronn"].bin}/ronn"

    bin.install "bin/git-lfs"
    man1.install Dir["man/man1/*.1"]
    man5.install Dir["man/man5/*.5"]
    man7.install Dir["man/man7/*.7"]
    doc.install Dir["man/html/*.html"]
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
