class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.12.1.0/cabal-install-3.12.1.0.tar.gz"
  sha256 "6848acfd9c726fdcce544a8b669748d0fd9f2da26d28e841069dc4840276b1b2"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.10"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7c4045e602d8d7def8ac0d2f75dfac407edee0f30c5bea42966382f3af0f259"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "078855c1050203d13a69f225ab2e3d41f6bafdce44ae420c6f811d0f5ccc5c55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d405f859c0761869218a0c6f7c4accbfe9bc044bcace7efa0c82fa89a76a7475"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1fd77bff8f6f5259c822b0fa41b52789e053c1e1fae86f584c1cd5e10cc4dc8"
    sha256 cellar: :any_skip_relocation, ventura:        "7df852785b8ede266ca04ef7d4d011737b8ceea70e653bb86243a9a41b95d995"
    sha256 cellar: :any_skip_relocation, monterey:       "288fb972a71efd34256e34e0d561a6ef8788cff17c6e530c744c251bca73feea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38c362e0ddb166707876b1849edc36af7a0c1dc370f1e47da81d3227216dc0e2"
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.3.0/cabal-install-3.10.3.0-aarch64-darwin.tar.xz"
        sha256 "f4f606b1488a4b24c238f7e09619959eed89c550ed8f8478b350643f652dc08c"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.3.0/cabal-install-3.10.3.0-x86_64-darwin.tar.xz"
        sha256 "3aed78619b2164dd61eb61afb024073ae2c50f6655fa60fcc1080980693e3220"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.3.0/cabal-install-3.10.3.0-aarch64-linux-deb11.tar.xz"
        sha256 "e0b6604d3596c5e5b7236e79ff4f5aa8af337792bf69ac4a90634c761f1b9ed5"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.3.0/cabal-install-3.10.3.0-x86_64-linux-ubuntu20_04.tar.xz"
        sha256 "b7ccb975bacf8b6a7d6b5dde8a7712787473a149c3dc0ebb2de7fbd00f964844"
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
    system bin/"cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
