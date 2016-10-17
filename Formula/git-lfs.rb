class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.4.3.tar.gz"
  sha256 "779755a6edece24467b21ac42543787bc56ed22066ce93e3e32921ca7555e925"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce3b30e34a61103b49d357aa5cccf7fbb9da550993c8777da0d9b1c1116675cb" => :sierra
    sha256 "a35175dff5341ebda814f502c4aadea67e7d7f08f2b7537318d1a76ed8b75aef" => :el_capitan
    sha256 "acb1a16e64832b7c571c12ba73a178348d968d110a246a25077b14f5eee6071a" => :yosemite
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
