class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.6.2.0/cabal-install-3.6.2.0.tar.gz"
  sha256 "dcf99e1d5f1c6e569e7386312fe96e9804b3cfb2d4f17ded1e01f60149bd3036"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.6"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1567f1329f94935dce0e58a095e0551a0e40f183f1c8251866aacae90f0c02dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bfe54303566dfca0274750039dc953af0eee3608a9e497104d717dee75cd8ad"
    sha256 cellar: :any_skip_relocation, monterey:       "3d35cad587ae87d2c0a1584418001eda21b7a78f8d63dc40ba6e8707b8403005"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7afa39e11ae84407293ea3baefb4587c56d682c9d705dc9649aa3f77c33a1b6"
    sha256 cellar: :any_skip_relocation, catalina:       "911813ba0f0038050e18c8c192e010efa02fcc75be1709efe34162f9f3a84e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c22f27d2d0f5ef085bf898b20ea122ddaf66f6ef06e0e2fd82f748ccb0a31ca"
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
