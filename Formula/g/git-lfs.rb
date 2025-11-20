class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.7.1/git-lfs-v3.7.1.tar.gz"
  sha256 "8f56058622edfea1d111e50e9844ef2f5ce670b2dbe4d55d48e765c943af4351"
  license "MIT"

  # Upstream creates releases that are sometimes not the latest stable version,
  # so we use the `github_latest` strategy to fetch the release tagged as "latest".
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edf7cb5683caadeca2318d455130e4e67ddae8647594760aad039f77c7712df1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edf7cb5683caadeca2318d455130e4e67ddae8647594760aad039f77c7712df1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edf7cb5683caadeca2318d455130e4e67ddae8647594760aad039f77c7712df1"
    sha256 cellar: :any_skip_relocation, sonoma:        "97e7aefe5058a1a4d7687c391c18baf20a2d6d387d038597de4d33002348c6eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0c10c6238b6b826c078809c7846b44d44ebed18212d61928dfca369e62c74db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93d215d3757e8e3249e22af329ade9d031312820e2e8565638d6c9f1337f4dd9"
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
