class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-3.4.0.0/cabal-install-3.4.0.0.tar.gz"
  sha256 "1980ef3fb30001ca8cf830c4cae1356f6065f4fea787c7786c7200754ba73e97"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/haskell/cabal.git", branch: "3.4"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20822cc6d4034500c82ba3a57f23d67311d140084fca0ac22f4877c0d8fbb31e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c1ecea50a86a48bd208e0163a319f2d2091b58568bf1f45abaa44cd92434f7a1"
    sha256 cellar: :any_skip_relocation, catalina:      "17983817b1da6b083fd3c046fb7268ff8f53d7f0a3cb7783d729297d1616c4a2"
    sha256 cellar: :any_skip_relocation, mojave:        "4e85f6fcbc380cd4c7fa1fbd23d0ec6065a6c848d5329d327008d3dfd7e860fa"
  end

  depends_on "ghc"
  uses_from_macos "zlib"

  resource "bootstrap" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-apple-darwin17.7.0.tar.xz"
        sha256 "9197c17d2ece0f934f5b33e323cfcaf486e4681952687bc3d249488ce3cbe0e9"
      else
        # Replace with a bootstrap binary when upstream provide one
        url "https://github.com/haskell/cabal/archive/fc4daed11271630aae1954e1520f9c16be2f4cd3.tar.gz"
        sha256 "21629b86d14c0ac0945e83271100afba66971484d7a057c12c1cafb8d887b41b"
      end
    end
    on_linux do
      url "https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz"
      sha256 "32d1f7cf1065c37cb0ef99a66adb405f409b9763f14c0926f5424ae408c738ac"
    end
  end

  resource "bootstrap-json" do
    url "https://github.com/haskell/cabal/files/6612159/darwin-8.10.5.json.zip"
    sha256 "16f65ec4d656e6c28979fd966597045015d7b9020a017889a512d4e347c2e770"
  end

  def install
    if Hardware::CPU.intel?
      resource("bootstrap").stage buildpath
    else
      resource("bootstrap").stage buildpath/"bootdir"
      resource("bootstrap-json").stage buildpath/"bootdir/bootstrap"
      cd "bootdir" do
        system "bootstrap/bootstrap.py",
                "-d", "bootstrap/darwin-8.10.5.json",
                "-w", Formula["ghc"].opt_bin/"ghc"
      end
      buildpath.install "bootdir/_build/bin/cabal"
    end

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
