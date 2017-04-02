class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.0.2.tar.gz"
  sha256 "e266bdffa53e947ba1d0bf8944d73029384bad2ed05af92bc10918d07eec6b63"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3414a8428b190fc67eb33d6de33df7d06155e327836658b9ea0c7e62b6b71fd" => :sierra
    sha256 "68cc2a111b3461790bb46467eb56c30a20a586a49984ff3b4ef4ece42165a3cc" => :el_capitan
    sha256 "db9d930626a054f4b334d45a5eb96d7f27ac5efae2706a4757f47bd10915e2c6" => :yosemite
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
