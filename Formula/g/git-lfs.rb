class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.7.0/git-lfs-v3.7.0.tar.gz"
  sha256 "d078b8393514c65c485d1628e610449ba048af746749912bd082d818b2454348"
  license "MIT"

  # Upstream creates releases that are sometimes not the latest stable version,
  # so we use the `github_latest` strategy to fetch the release tagged as "latest".
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e905231194b4144c52b981a2a52868f6fb2c8ffc27099a0771362dc45890879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e905231194b4144c52b981a2a52868f6fb2c8ffc27099a0771362dc45890879"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e905231194b4144c52b981a2a52868f6fb2c8ffc27099a0771362dc45890879"
    sha256 cellar: :any_skip_relocation, sonoma:        "db9022729517fff9457056b559e9d43db5bba5531ae9b636f140ce41bb4e0d95"
    sha256 cellar: :any_skip_relocation, ventura:       "db9022729517fff9457056b559e9d43db5bba5531ae9b636f140ce41bb4e0d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6926c738974ed58fb5dec2bf00cbb4f759db8d7e8554c347d7d039a7135ba4da"
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
