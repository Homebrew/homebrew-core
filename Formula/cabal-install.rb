class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.6.0.0/cabal-install-3.6.0.0.tar.gz"
  sha256 "819caf018578bf19d9f5ffa6eba1cfe9d192eacf539d2210a51358192cc15047"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.6"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7a43c82ce306b25d0e223575c683a93670eff2717428cdcd0559144bc32b277"
    sha256 cellar: :any_skip_relocation, big_sur:       "1588cf8cfff0a991adf3681db660098a02002c3ca62f9dc80f6b4f3f514e8d79"
    sha256 cellar: :any_skip_relocation, catalina:      "be48473b083335fca3ad94a704f726d6c29efcd0833a8e8eaaf4fc59ad50ea7f"
    sha256 cellar: :any_skip_relocation, mojave:        "0f57d19230fa149e0f5e34378e29cf1c4d8061f7e6417faf2d71d87cbc3c1eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a740680a6779161ad8775dbe0f975b0ef5ab6038d0274b6ec97be4f2cbc071"
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
