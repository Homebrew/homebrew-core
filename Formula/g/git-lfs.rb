class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.github.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.4.0/git-lfs-v3.4.0.tar.gz"
  sha256 "d65795242550a9ed823979282cc3572a7b221f9be3440b9bf3a1d6d81c51a416"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fb45479f699c517bcc3dc2cc4f983edf6f29fdb4c2919774620033f9261d18f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fb45479f699c517bcc3dc2cc4f983edf6f29fdb4c2919774620033f9261d18f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fb45479f699c517bcc3dc2cc4f983edf6f29fdb4c2919774620033f9261d18f"
    sha256 cellar: :any_skip_relocation, ventura:        "c1a2458c826860845f30ab65505d679f8752fad0c920f3ae7401af5bfa8f5491"
    sha256 cellar: :any_skip_relocation, monterey:       "c1a2458c826860845f30ab65505d679f8752fad0c920f3ae7401af5bfa8f5491"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1a2458c826860845f30ab65505d679f8752fad0c920f3ae7401af5bfa8f5491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4128774cc6771a7a768902f7520fc9e95445b1cf646f4236bd7affb1ecda98c9"
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
