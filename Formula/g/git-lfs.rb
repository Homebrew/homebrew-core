class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.8.0/git-lfs-v3.8.0.tar.gz"
  sha256 "4f75492c6832038fa73d39a45316657208bb6caa23b273451cb4ec2358d42ccb"
  license "MIT"
  compatibility_version 1

  # Upstream creates releases that are sometimes not the latest stable version,
  # so we use the `github_latest` strategy to fetch the release tagged as "latest".
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc0386b26592dae0d520035a59014db85589a5f586f57665b4fa00eea3d95351"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fcefb0b6742a77251b31a71780e91baba1cc02d23e2d36ef577fc91d4e74d751"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcefb0b6742a77251b31a71780e91baba1cc02d23e2d36ef577fc91d4e74d751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fcefb0b6742a77251b31a71780e91baba1cc02d23e2d36ef577fc91d4e74d751"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "91f4dd352c1bb1963b87143524fc732e09ebc453d826a794e1e7bd15c0a55c1c"
    sha256 cellar: :any,                 x86_64_linux:      "518268f40ab88089067c73ecde9776aa96e9cdd0c7d5e2f54561440065c5ee3d"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
