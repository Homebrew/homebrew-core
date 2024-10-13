class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.12.1.0/cabal-install-3.12.1.0.tar.gz"
  sha256 "6848acfd9c726fdcce544a8b669748d0fd9f2da26d28e841069dc4840276b1b2"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.12"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6d973fbc7b286f613320ff1a359023078ab06aa8e87209c8f785e601d452fbca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f6c8f744e69dc10b3512979588c0730147d0f2ae09c2d990953a3cb87f0cd8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d74da35f87ef2ebbed1f38e3bd83661579d822a86f41aa32c0c7d59af3d2e6fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b38e6149b74b53c25b2493bf6a208ff8093a2cad6003d33ab2a0380611ebb049"
    sha256 cellar: :any_skip_relocation, sonoma:         "14b2ef3160b714b0f8105f32b35c3f06978b37eb0a9ca05fc1874266938663f3"
    sha256 cellar: :any_skip_relocation, ventura:        "2ee5bc7a0cc5d2e6e758ae8d01b0adfe29073d0e8dd0e96c3a9eed852a064520"
    sha256 cellar: :any_skip_relocation, monterey:       "49b7a075b4dd8c82487206c31f2b8d05084f5a189689d015c0fe2203427ef9e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb3155168d1f4d92e6277b7af7fcd99e0ff9519d56097030a0cff7d5690a71a8"
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
        url "https://downloads.haskell.org/~cabal/cabal-install-3.10.3.0/cabal-install-3.10.3.0-aarch64-linux-deb10.tar.xz"
        sha256 "92d341620c60294535f03098bff796ef6de2701de0c4fcba249cde18a2923013"
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
    system bin/"cabal", "--config-file=#{testpath}/config", "v2-update"
    system bin/"cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
