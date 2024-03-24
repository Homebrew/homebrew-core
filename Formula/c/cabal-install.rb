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
