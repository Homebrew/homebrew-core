class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.10"

  stable do
    url "https://downloads.haskell.org/~cabal/cabal-install-3.10.1.0/cabal-install-3.10.1.0.tar.gz"
    sha256 "995de368555449230e0762b259377ed720798717f4dd26a4fa711e8e41c7838d"

    # Use Hackage metadata revision to support GHC 9.6.
    # TODO: Remove this resource on next release along with corresponding install logic
    resource "cabal-install.cabal" do
      url "https://hackage.haskell.org/package/cabal-install-3.10.1.0/revision/1.cabal"
      sha256 "7668e8dcd3612d8520e16f420c973cd5ceeddb8237422e800067d6c367523940"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a13e9e35906f7bebfe3eed6ed30eeb6eef33c214150ad9e962cb533bedcb61d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d971441087454c80f4496d42b9ce15517e54975f73dc4d1417935db7f0f8bbc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf1653dbd912c65d6028abf2a2f21a589e34b5a37eea0f8557406748421f7e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f593288503f68e9a7d0b0c9869fb0a4cf9014dd63c042fdf6cf8661534a9c78"
    sha256 cellar: :any_skip_relocation, ventura:        "a985d2fddefd0bb9683351f1833f92a9ec4c196cdde0b92d182246e901ed3417"
    sha256 cellar: :any_skip_relocation, monterey:       "b3eea63092feeb5ee050ec741b2cc3a6adfac9ad1a179b1735727573a5dc9a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc550f7b66551aaf9b25b32f10d26a602af44d8699df9475760a96260c7b522"
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.1.0/cabal-install-3.10.1.0-aarch64-darwin.tar.xz"
        sha256 "fdabdc4dca42688a97f2b837165af42fcfd4c111d42ddb0d4df7bbebd5c8750e"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.1.0/cabal-install-3.10.1.0-x86_64-darwin.tar.xz"
        sha256 "893a316bd634cbcd08861306efdee86f66ec634f9562a8c59dc616f7e2e14ffa"
      end
    end
    on_linux do
      url "https://downloads.haskell.org/~cabal/cabal-install-3.10.1.0/cabal-install-3.10.1.0-x86_64-linux-ubuntu20_04.tar.xz"
      sha256 "b0752c4c5e53eec56af23a1e7cd5a18b5fc62dd18988962aa0aa8748a22af52d"
    end
  end

  def install
    resource("cabal-install.cabal").stage { buildpath.install "1.cabal" => "cabal-install.cabal" } unless build.head?
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
