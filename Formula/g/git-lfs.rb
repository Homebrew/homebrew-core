class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.6.1/git-lfs-v3.6.1.tar.gz"
  sha256 "1417b7ee9a8fba8d649a89f070fdcde8b2593ca2caa74e3e808d2bb35d5ca5f7"
  license "MIT"

  # Upstream creates releases that are sometimes not the latest stable version,
  # so we use the `github_latest` strategy to fetch the release tagged as "latest".
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea6fd17f274522756b7a4b17960121d9f029c8926e3f27e116552680e3ea215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fea6fd17f274522756b7a4b17960121d9f029c8926e3f27e116552680e3ea215"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fea6fd17f274522756b7a4b17960121d9f029c8926e3f27e116552680e3ea215"
    sha256 cellar: :any_skip_relocation, sonoma:        "7951618702479a261a57b3f0db12f3d3ff697be18dff94f8c4ae7be813a0c916"
    sha256 cellar: :any_skip_relocation, ventura:       "7951618702479a261a57b3f0db12f3d3ff697be18dff94f8c4ae7be813a0c916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "649a26347d7b861008caca73dbd1853c36d81d3b51e08fa86fe225249d124064"
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
