class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.14.1.1/cabal-install-3.14.1.1.tar.gz"
  sha256 "f11d364ab87fb46275a987e60453857732147780a8c592460eec8a16dbb6bace"
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

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-aarch64-darwin.tar.xz"
        sha256 "9c165ca9a2e593b12dbb0eca92c0b04f8d1c259871742d7e9afc352364fe7a3f"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-x86_64-darwin.tar.xz"
        sha256 "e89392429f59bbcfaf07e1164e55bc63bba8e5c788afe43c94e00b515c1578af"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-aarch64-linux-deb10.tar.xz"
        sha256 "c01f2e0b3ba1fe4104cf2933ee18558a9b81d85831a145e8aba33fa172c7c618"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-x86_64-linux-ubuntu20_04.tar.xz"
        sha256 "3724f2aa22f330c5e6605978f3dd9adee4e052866321a8dd222944cd178c3c24"
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
