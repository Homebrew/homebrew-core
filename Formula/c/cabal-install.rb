class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.16.0.0/cabal-install-3.16.0.0.tar.gz"
  sha256 "282a499fe3beeee0a2a50dc1adf264c204a090873679e2753e0355d6cf6c561a"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.16"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0144bed245e8dbc50270243010162b7e02c15cbb617e091a24ef4ef4d0e60630"
    sha256 cellar: :any,                 arm64_sequoia: "0c9fd4abd5dcc2bd5b30c5a4d5200231f12631a05592a1053bd767a05e00bc58"
    sha256 cellar: :any,                 arm64_sonoma:  "681c54b7997d6fba9d6e126dec76e727eb478300ce7ce3982eee252fc6b4109a"
    sha256 cellar: :any,                 arm64_ventura: "d2f8ed39fc3b8e068d158ec33dd2fa6c57dd44877a622b7a431190c4716f6446"
    sha256 cellar: :any,                 sonoma:        "8e4b24151c8f14fac714a5ad33eb21d92add3fb6b081248aa8cda69bec4653bb"
    sha256 cellar: :any,                 ventura:       "1ba4d13261deb28ca5cc41da5aeed93a10447024fb46d080e271ad41f2be145f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b52abb52d9b1c628fa91b2e59dec5cd20b6060ed9c74e462f2fb9b16f70da4d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa2b8c45e87fb83aca1bf2fc72ee85fa18962c2432bbb6927d0562907faf6aa3"
  end

  depends_on "ghc"
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  # Make sure bootstrap version supports GHC provided by Homebrew
  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.14.2.0/cabal-install-3.14.2.0-aarch64-darwin.tar.xz"
        sha256 "c599c888c4c72731a2abbbab4c8443f9e604d511d947793864a4e9d7f9dfff83"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.14.2.0/cabal-install-3.14.2.0-x86_64-darwin.tar.xz"
        sha256 "f9d0cac59deeeb1d35f72f4aa7e5cba3bfe91d838e9ce69b8bc9fc855247ce0f"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.14.2.0/cabal-install-3.14.2.0-aarch64-linux-deb10.tar.xz"
        sha256 "63ee40229900527e456bb71835d3d7128361899c14e691cc7024a5ce17235ec3"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.14.2.0/cabal-install-3.14.2.0-x86_64-linux-ubuntu20_04.tar.xz"
        sha256 "974a0c29cae721a150d5aa079a65f2e1c0843d1352ffe6aedd7594b176c3e1e6"
      end
    end
  end

  def install
    resource("bootstrap").stage buildpath
    cabal = buildpath/"cabal"
    cd "cabal-install" if build.head?
    system cabal, "v2-update"
    system cabal, "v2-install", *std_cabal_v2_args
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system bin/"cabal", "--config-file=#{testpath}/config", "user-config", "init"
    system bin/"cabal", "--config-file=#{testpath}/config", "v2-update"
    system bin/"cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
