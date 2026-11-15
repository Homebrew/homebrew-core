class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.8.1/git-lfs-v3.8.1.tar.gz"
  sha256 "1939307bef808580f7c8954ede7072889d7e76721f5d6fdc4ab110bf907330ab"
  license "MIT"
  compatibility_version 1

  # Upstream creates releases that are sometimes not the latest stable version,
  # so we use the `github_latest` strategy to fetch the release tagged as "latest".
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eeebeea7809cebc90dc539f5c72fe607f5418f346e855a159c08d6b453f8b088"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eeebeea7809cebc90dc539f5c72fe607f5418f346e855a159c08d6b453f8b088"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eeebeea7809cebc90dc539f5c72fe607f5418f346e855a159c08d6b453f8b088"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8f482de6c05507eafc2132cc82400f73687f8768b6d43c6002571eb045f4c158"
    sha256 cellar: :any,                 x86_64_linux:      "16986c189e2c86839c171a8ce1d6d05baebf5bf34825cfbe6db5cf821306a308"
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
