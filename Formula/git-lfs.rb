class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.0.1.tar.gz"
  sha256 "62887214d90f0c1d1ba3da45112dffcc1d6bd1d1fabc9ef1e1ab85341242b11f"

  bottle do
    cellar :any_skip_relocation
    sha256 "220429375d648e3cd214c1267e024335d31334f4c9c70e17be61b3cca3adf187" => :sierra
    sha256 "9e772228201aef3e0a1fda7365e8423a8aa06be52c96f047494fcd2546ca77e3" => :el_capitan
    sha256 "7d6cff16ddcc143771726d1fbc7ef55f406b451ab5ab4a83d897059cc6150f21" => :yosemite
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
