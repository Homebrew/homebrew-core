class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  # TODO: Try removing --constraint in next release of `cabal-install` or `ghc`.
  # GHC 9.8.1 includes Cabal 3.10.2.0 which has an issue building Objective-C sources.
  # Issue ref: https://github.com/haskell/cabal/issues/9190
  url "https://hackage.haskell.org/package/cabal-install-3.10.3.0/cabal-install-3.10.3.0.tar.gz"
  sha256 "a8e706f0cf30cd91e006ae8b38137aecf65983346f44d0cba4d7a60bbfa3da9e"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.10"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db4e8b22d4eb6c3cf26b41d9377e258ae31ab7a57fa2dd63d94db1770a492225"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "882064351b396b55b4ba0f5694ba84e93e302bf0e2be33e84874dfbf249358f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a302c5e79dd7a00ca9a916a3089de8d61f48ea7927fd531d6c64fb1f746103ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ec3cd0aab2bec8f225d27052e3568b7ffa67b7651ffec853e526f1ec6517b53"
    sha256 cellar: :any_skip_relocation, ventura:        "1f47d35b92f50cd8917697462da5756df57de2c11adb0f4d37ed6262cb211da9"
    sha256 cellar: :any_skip_relocation, monterey:       "73377aa93b67cd71b9aa30505bb18097f5662fb9e659119b60bb51ccb9e020c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92b061b878d9eb6140b2a8ccc1f8b8d357e30dd3aa5d1ed97fd33c93c8c4ca49"
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-aarch64-darwin.tar.xz"
        sha256 "d2bd336d7397cf4b76f3bb0d80dea24ca0fa047903e39c8305b136e855269d7b"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-x86_64-darwin.tar.xz"
        sha256 "cd64f2a8f476d0f320945105303c982448ca1379ff54b8625b79fb982b551d90"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-aarch64-linux-deb11.tar.xz"
        sha256 "daa767a1b844fbc2bfa0cc14b7ba67f29543e72dd630f144c6db5a34c0d22eb1"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-x86_64-linux-ubuntu20_04.tar.xz"
        sha256 "c2a8048caa3dbfe021d0212804f7f2faad4df1154f1ff52bd2f3c68c1d445fe1"
      end
    end
  end

  def install
    resource("bootstrap").stage buildpath
    cabal = buildpath/"cabal"
    cd "cabal-install" if build.head?
    system cabal, "v2-update"
    system cabal, "v2-install", "--constraint=Cabal>=3.10.2.1", *std_cabal_v2_args
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system bin/"cabal", "--config-file=#{testpath}/config", "user-config", "init"
    system bin/"cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
