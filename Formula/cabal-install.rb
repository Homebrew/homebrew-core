class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.8.1.0/cabal-install-3.8.1.0.tar.gz"
  sha256 "61ce436f2e14e12bf07ea1c81402362f46275014cd841a76566f0766d0ea67e6"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.8"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cf0bd1fa1bc4afb62e7fad74b92ae6f28798d63814d195fa5741b3c3821aa43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4783fe7f7d8e7ae44bf6752c887819fab673d15c41c617fa8dce215ee8304eef"
    sha256 cellar: :any_skip_relocation, ventura:        "0c6a4adb2d333719844c60974a57d787671ce6e688389ae0c1ec51f2432c1539"
    sha256 cellar: :any_skip_relocation, monterey:       "0662573e0cae281e74e8283a9d4d33bf384728183915dc8391d9c1317e3e50db"
    sha256 cellar: :any_skip_relocation, big_sur:        "a01863975ff22421990a6c70929701a6ba21675b6b4a371d79349e506b015c6b"
    sha256 cellar: :any_skip_relocation, catalina:       "9c52b90081efda0ef6bb21357c76901f2b94677ae86434d06e377f950f978829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17c419427fd0060bbfb347184732358eb8a48bb4c60d613e358797f0207a5573"
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-apple-darwin17.7.0.tar.xz"
        sha256 "9197c17d2ece0f934f5b33e323cfcaf486e4681952687bc3d249488ce3cbe0e9"
      end
      on_arm do
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
    system bin/"cabal", "--config-file=#{testpath}/config", "user-config", "init"
    system bin/"cabal", "--config-file=#{testpath}/config", "info", "Cabal"
  end
end
