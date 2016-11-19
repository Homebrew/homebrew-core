class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v1.5.1.tar.gz"
  sha256 "78ccf3c1161a09315ce0d5cb95d11e4460c88c30e2f3487f773d7acc43a13682"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4d01dcb68c53f7d9082a3ade38f3b68d9551f8f36fee44b8b063622651fcd31" => :sierra
    sha256 "a7d7ed40b8f2344b49d45a6264807eb94a977a844a09de720379d99e00ef07e4" => :el_capitan
    sha256 "123388ded4361626c3fbeb4823b7db29e0ab4682839d58c49ea61bdd0a347ae3" => :yosemite
  end

  depends_on "go" => :build

  def install
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  def caveats; <<-EOS.undent
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
