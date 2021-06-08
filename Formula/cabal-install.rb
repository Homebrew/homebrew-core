class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.4.0.0/cabal-install-3.4.0.0.tar.gz"
  sha256 "1980ef3fb30001ca8cf830c4cae1356f6065f4fea787c7786c7200754ba73e97"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/haskell/cabal.git", branch: "3.4"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2278e214a2049f3c96f6e7a331db424f4318fddd16112eadd0327ba09d5ff706"
    sha256 cellar: :any_skip_relocation, catalina: "2d413e0af2bd35e151423a1ad764c471a397bdab5f04a337c31adb96480bdb84"
    sha256 cellar: :any_skip_relocation, mojave:   "ce70ecbdf305bbefa6bfe41dab1d5e3087e5062e64d500277c7ec9aa71d792bc"
  end

  depends_on "ghc" if MacOS.version >= :catalina
  uses_from_macos "zlib"

  on_macos { depends_on "ghc@8.8" if MacOS.version <= :mojave }
  on_linux { depends_on "ghc" }

  resource "bootstrap" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-apple-darwin17.7.0.tar.xz"
        sha256 "9197c17d2ece0f934f5b33e323cfcaf486e4681952687bc3d249488ce3cbe0e9"
      else
        # Bootstrapped on Homebrew CI. Replace with official upstream artefact when one is available.
        url "https://github.com/haskell/cabal/files/6617482/cabal-install-3.5-arm64-darwin-11.4-bootstrapped.tar.gz"
        sha256 "e6f2c70fe8946df3980899bd1c564ffea55630b57238cdac9de851178e644a53"
      end
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
