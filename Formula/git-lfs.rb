class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v1.5.2.tar.gz"
  sha256 "e452948ba1ab455516c81b41d5c85af8bba432297883e8770ade51d74762beaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7191e0eb9b035c607a3f8d5a477e3517fee8cc2e560e3c70f6bf1f13ac16f82" => :sierra
    sha256 "dc9deb346d10203a64b9e5bb48c374fc832eeb1ec5a4de7313e2810591d0f5a9" => :el_capitan
    sha256 "25a7116173f9d0c0d43b18c98a7717de8e705c87dbc8d81bcc714deb5efb6555" => :yosemite
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
