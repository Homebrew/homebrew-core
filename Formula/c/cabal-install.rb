class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.14.2.0/cabal-install-3.14.2.0.tar.gz"
  sha256 "e8a13d7542040aad321465a576514267a753d02808a98ab17751243c131c7bdb"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.14"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d6b9eea47a6d667685e4b687469ffc3ea5a1eac6790629ace17d39c4789e85b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6433e78d1f8658935d46a92db1413c091ed6274885266e479eb26fa8370dd124"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35f8c9c087cf7be5efbfa16248cda01f7fc64bfddf969dd4c0bc7c948f14a5c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "23ae2f85cc3dab2e22ddf853b2479fe0c16a43f089c44242bb065ec8f846faf5"
    sha256 cellar: :any_skip_relocation, ventura:       "2e541aa04959d1550d57bab5f938c11c89e725160565318d5e7e9228bbfa234e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "305b229f4b2de647cbd67e93ca479ccc70ac0870c3c52c19e0a112b88666add6"
  end

  depends_on "ghc"
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
