class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.4.0.0/cabal-install-3.4.0.0.tar.gz"
  sha256 "1980ef3fb30001ca8cf830c4cae1356f6065f4fea787c7786c7200754ba73e97"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/haskell/cabal.git", branch: "3.4"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2c0c5cc90d4739515721557f8e9c02783b3b5f106033c5c09241657b4418b21f"
    sha256 cellar: :any_skip_relocation, catalina: "14be4fa563d51c78f570a4d58746fea563e33f94fdd288f907d4892b2a763eec"
    sha256 cellar: :any_skip_relocation, mojave:   "7b0fdd86bd545b19defa1b89e98f31aff6d3b7519b98cd76f52c1641b50a92ad"
  end

  depends_on "ghc" if MacOS.version >= :catalina
  uses_from_macos "zlib"

  on_macos { depends_on "ghc@8.8" if MacOS.version <= :mojave }
  on_linux { depends_on "ghc" }

  resource "bootstrap" do
    on_macos do
      url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-apple-darwin17.7.0.tar.xz"
      sha256 "9197c17d2ece0f934f5b33e323cfcaf486e4681952687bc3d249488ce3cbe0e9"
    end
    on_linux do
      url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz"
      sha256 "32d1f7cf1065c37cb0ef99a66adb405f409b9763f14c0926f5424ae408c738ac"
    end
  end

  def install
    resource("bootstrap").stage buildpath
    cabal = buildpath/"cabal"
    cd "cabal-install" if build.head?

    system cabal, "v2-update"
    system cabal, "v2-install", *std_cabal_v2_args
    bash_completion.install "bash-completion/cabal"

    on_macos do
      if MacOS.version <= :mojave
        (libexec/"bin").install bin/"cabal"
        (bin/"cabal").write_env_script libexec/"bin/cabal", PATH: "$PATH:#{Formula["ghc@8.8"].opt_bin}"
      end
    end
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
