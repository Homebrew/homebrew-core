class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.18.2.0/cabal-install-3.18.2.0.tar.gz"
  sha256 "1d55fea99bf82b2f4a2ae51bd47313167048ba05aac6290a30752d91cd5f7cb8"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e8a22d63f75f48a9aa72b598547e759380799e3814760880df6f81bba8d7d6c2"
    sha256 cellar: :any, arm64_tahoe:       "e13c6ede5f2e25dd19b7d58ca06fc5129103e3dcbfb648732847e3d3f5c7a7a9"
    sha256 cellar: :any, arm64_sequoia:     "5bce40512dced3f12d8511bee51b1661021ea097aa66457d76d48e69c07d5a7b"
    sha256 cellar: :any, arm64_linux:       "7afc31d2b0bbb28005fbba15c1461455f8fc20e40f6fa2db810efe45137e3d52"
    sha256 cellar: :any, x86_64_linux:      "8c9cad0a3f393454cc3bc05a2796773882ad06e0f8178aadedc275622e454599"
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
