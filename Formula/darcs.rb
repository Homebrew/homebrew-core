class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.14.4/darcs-2.14.4.tar.gz"
  sha256 "e7721151000857a6ab53d7ee82a3d3e8e741b19c2cff0da2a2c9dc1285026762"

  bottle do
    cellar :any_skip_relocation
    sha256 "a03abe9838c948f87f9ceb1e10e2c5e3d0483022eb0b7184043a65ac3d7109d2" => :catalina
    sha256 "ed8b61d553e3c4d15b6c1bc898bb2cc28314599309b7a68ad97120753b4114e4" => :mojave
    sha256 "80a61a6abc44c1f7a759c279966024bf994ab391174bcf39df74269a2f50e6f3" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    mkdir "my_repo" do
      system bin/"darcs", "init"
      (Pathname.pwd/"foo").write "hello homebrew!"
      system bin/"darcs", "add", "foo"
      system bin/"darcs", "record", "-am", "add foo", "--author=homebrew"
    end
    system bin/"darcs", "get", "my_repo", "my_repo_clone"
    cd "my_repo_clone" do
      assert_match "hello homebrew!", (Pathname.pwd/"foo").read
    end
  end
end
