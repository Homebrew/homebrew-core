class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.14.2.0/cabal-install-3.14.2.0.tar.gz"
  sha256 "e8a13d7542040aad321465a576514267a753d02808a98ab17751243c131c7bdb"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.14"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb4c5b451162c33c333592e952278831d2db5f4dbf62658d5860c1745a2ad710"
    sha256 cellar: :any,                 arm64_sonoma:  "d01fea15c88a36df7f7d0212160718d1ccf4edaee43ce7d813e886dc5ab6dc1d"
    sha256 cellar: :any,                 arm64_ventura: "eb1eee51d48816906c4ac3372812c89d9bbcaee36c66fb0dd2f18c5c694dfccf"
    sha256 cellar: :any,                 sonoma:        "e98155ea810622b58914f45f36e85fcba01698c29b0cc53132d9b7032ad3e4f8"
    sha256 cellar: :any,                 ventura:       "06509d41498a8a811293a1eb4adb22363543ab521d58b3f92aeb536fb512bcdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec83150f7dbbfe3b257c679dd8357800bedb9ce65961306c088a020969b04298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eede6ad6ceac8c6b92a84e5930ec78533b89fac6b7b98999a54bbfd6623c9f5d"
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
