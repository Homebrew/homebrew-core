class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.18.1.0/cabal-install-3.18.1.0.tar.gz"
  sha256 "7e5c3f5e53f7c91f9ff8f0fb075574e772562d0eeb400c402c7d9277558f0821"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "473d34a30b9fc3d87a04787cb6c2c8716c48f1bfa20accbead8dc857e61652c0"
    sha256 cellar: :any, arm64_sequoia: "ebe7dcba714fdcefeec0ed65d2df2ac5cca0759674a4074873977d759a854808"
    sha256 cellar: :any, arm64_sonoma:  "a91a0512a3f0b41d424a4ddeab0cff4318565574a1b3211529a99744ec6de289"
    sha256 cellar: :any, sonoma:        "ed6968cd7f7cf837bdb229f79d111d0d2cfac06a8b8add2f2bfe1e9b47705065"
    sha256 cellar: :any, arm64_linux:   "84f496193d18b2765e442c04fa4a3a4201685aa2797d8c86a75d10854d3b0e6a"
    sha256 cellar: :any, x86_64_linux:  "1a46769f5d35b4d6e03f8185eae6342bfa7b99be1c75eaa7fd989953e601a6ee"
  end

  depends_on "ghc" => [:build, :test]
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    resource("bootstrap").stage(buildpath/"bin")
    cabal = buildpath/"bin/cabal"
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
