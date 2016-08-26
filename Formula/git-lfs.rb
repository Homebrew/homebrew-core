class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.4.1.tar.gz"
  sha256 "5c2b6640d965a0ed334c6a7e4a5e327c7543234d3f2a2c7879d5b9731ef82c4b"

  bottle do
    cellar :any_skip_relocation
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
