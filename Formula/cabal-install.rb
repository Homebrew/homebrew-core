class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.8"

  stable do
    url "https://hackage.haskell.org/package/cabal-install-3.8.1.0/cabal-install-3.8.1.0.tar.gz"
    sha256 "61ce436f2e14e12bf07ea1c81402362f46275014cd841a76566f0766d0ea67e6"

    # Use Hackage metadata revision to support GHC 9.4.
    # TODO: Remove this resource on next release along with corresponding install logic
    resource "cabal-install.cabal" do
      url "https://hackage.haskell.org/package/cabal-install-3.8.1.0/revision/2.cabal"
      sha256 "e29a58254bb8aaf950bf541e0fe9cf63f9ae99b8ae1f7f47b62b863c25dd54d0"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40ab69cd21f54e597795b71abf344665072feb6ac2b03bd2bae0e04bb631ef83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3af91ef28d8d82761de341be8277b8ab61c50c9c222d27ff1f6265ec11595be2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "252fe73c7aaf9c44ef3a2f7dc25bc89230a614591dcd6efcf1a8ccc8bec901ac"
    sha256 cellar: :any_skip_relocation, ventura:        "c1d60e3d027bdef6559d3128c4139bc1d93a73cc3e60323c4a135eb948962c76"
    sha256 cellar: :any_skip_relocation, monterey:       "a682772e0cf626c821efd4d884737e33104831d1e5ab2ce6f90be557aa872ca6"
    sha256 cellar: :any_skip_relocation, big_sur:        "395c7c55426e70ecadbcfd943d9b4e0a4cd8799331a2f0b585289bd0a93f8c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d84d35b0bd0a269423bb92082e848227f24c3fe61549da35b42da32c46effae"
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.6.2.0/cabal-install-3.6.2.0-aarch64-darwin.tar.xz"
        sha256 "859c526cde4498879a935e38422d3a0b70ae012dff034913331be8dd429a4a74"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-apple-darwin17.7.0.tar.xz"
        sha256 "9197c17d2ece0f934f5b33e323cfcaf486e4681952687bc3d249488ce3cbe0e9"
      end
    end
    on_linux do
      url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz"
      sha256 "32d1f7cf1065c37cb0ef99a66adb405f409b9763f14c0926f5424ae408c738ac"
    end
  end

  def install
    resource("cabal-install.cabal").stage { buildpath.install "2.cabal" => "cabal-install.cabal" } unless build.head?
    resource("bootstrap").stage buildpath
    cabal = buildpath/"cabal"
    cd "cabal-install" if build.head?
    system cabal, "v2-update"
    system cabal, "v2-install", *std_cabal_v2_args
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system bin/"cabal", "--config-file=#{testpath}/config", "user-config", "init"
    system bin/"cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
