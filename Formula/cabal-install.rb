class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.4.0.0/cabal-install-3.4.0.0.tar.gz"
  sha256 "1980ef3fb30001ca8cf830c4cae1356f6065f4fea787c7786c7200754ba73e97"
  license "BSD-3-Clause"
  head "https://github.com/haskell/cabal.git", branch: "3.4"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e5cf4ef514f88918a5eb50b704b97cd5a335d9112b2458d19ba6ed2520e8da2c"
    sha256 cellar: :any_skip_relocation, catalina: "28a4d8d675adfd734abf2bc4294a1587caca5bf34c1a8e5dbf5c7bea03d36513"
    sha256 cellar: :any_skip_relocation, mojave:   "e9bdce7d81f4a3135f054da0cf596d23a22b3996f1264614e0a87a21c5b9be55"
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  resource "bootstrap" do
    url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-apple-darwin17.7.0.tar.xz"
    sha256 "9197c17d2ece0f934f5b33e323cfcaf486e4681952687bc3d249488ce3cbe0e9"
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
