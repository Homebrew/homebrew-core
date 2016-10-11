class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.4.2.tar.gz"
  sha256 "3bba0679a7d8b8684011b43a33c9d1571e7d07ba84965ebf50da554f10cedf98"

  bottle do
    cellar :any_skip_relocation
    sha256 "d293874293c57d6ed922f3193c1cf09a76c0867ae7153fa0eb85d22a497db299" => :sierra
    sha256 "aa45170d657b4cec16d9aa793f0958db3b47b11cf9bc07fa2aaf31fccdc5324e" => :el_capitan
    sha256 "519300efced3a82e219edc4a23aacf486212e2e0303ef29642e26bc7b656bfb9" => :yosemite
    sha256 "b70269206360e38015f46b7838270921da2266f4358cba98c0ac7949ffa43d36" => :mavericks
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
