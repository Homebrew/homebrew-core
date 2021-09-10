class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.6.0.0/cabal-install-3.6.0.0.tar.gz"
  sha256 "819caf018578bf19d9f5ffa6eba1cfe9d192eacf539d2210a51358192cc15047"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.6"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20822cc6d4034500c82ba3a57f23d67311d140084fca0ac22f4877c0d8fbb31e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c1ecea50a86a48bd208e0163a319f2d2091b58568bf1f45abaa44cd92434f7a1"
    sha256 cellar: :any_skip_relocation, catalina:      "17983817b1da6b083fd3c046fb7268ff8f53d7f0a3cb7783d729297d1616c4a2"
    sha256 cellar: :any_skip_relocation, mojave:        "4e85f6fcbc380cd4c7fa1fbd23d0ec6065a6c848d5329d327008d3dfd7e860fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ecb7047ab4c4dbc1c2407b76ac7062bcb0d312defbc411f06fdb67fa87e00c4"
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-apple-darwin17.7.0.tar.xz"
        sha256 "9197c17d2ece0f934f5b33e323cfcaf486e4681952687bc3d249488ce3cbe0e9"
      else
        # https://github.com/haskell/cabal/issues/7433#issuecomment-858590474
        url "https://downloads.haskell.org/~ghcup/unofficial-bindists/cabal/3.6.0.0/cabal-install-3.6.0.0-aarch64-darwin-big-sur.tar.xz"
        sha256 "7acf740946d996ede835edf68887e6b2f1e16d1b95e94054d266463f38d136d9"
      end
    end
    on_linux do
      url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz"
      sha256 "32d1f7cf1065c37cb0ef99a66adb405f409b9763f14c0926f5424ae408c738ac"
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
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
