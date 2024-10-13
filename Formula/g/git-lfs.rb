class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.github.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.5.1/git-lfs-v3.5.1.tar.gz"
  sha256 "fc19c7316e80a6ef674aa4e1863561c1263cd4ce0588b9989e4be9461664d752"
  license "MIT"

  # Upstream creates releases that are sometimes not the latest stable version,
  # so we use the `github_latest` strategy to fetch the release tagged as "latest".
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ae42cee04c1e4c25cfe7c2cfbde067060b1b96ac1ec80da9d63c5a4b4e0c909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ae42cee04c1e4c25cfe7c2cfbde067060b1b96ac1ec80da9d63c5a4b4e0c909"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ae42cee04c1e4c25cfe7c2cfbde067060b1b96ac1ec80da9d63c5a4b4e0c909"
    sha256 cellar: :any_skip_relocation, sonoma:        "63e2c1dbdc3df326ddea622cd7d134935a9545ab14f5bc871b23739b82792c67"
    sha256 cellar: :any_skip_relocation, ventura:       "63e2c1dbdc3df326ddea622cd7d134935a9545ab14f5bc871b23739b82792c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f8525605ee1028c3a5e2dd762270b3a89da7e3b1355ee701bc791a5272ad843"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    system "make"
    system "make", "man"

    bin.install "bin/git-lfs"
    man1.install Dir["man/man1/*.1"]
    man5.install Dir["man/man5/*.5"]
    man7.install Dir["man/man7/*.7"]
    doc.install Dir["man/html/*.html"]
    generate_completions_from_executable(bin/"git-lfs", "completion")
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
