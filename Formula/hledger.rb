require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.16.2/hledger-1.16.2.tar.gz"
  sha256 "b4b78b3f08d00ca75c6f6d47b37c0a67aec4adc0aefff2ca29bb0f3b82ac7bcb"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a2ce1e953222966b73fdcbb7ea164b49adaf6fbf00eba6795f4d32dd210a958" => :catalina
    sha256 "ddf79feacd34196d4b92976133dda1de97b53514ed4d1bf9d4c0206bcb330fe2" => :mojave
    sha256 "22f6bd98c3b593aa5ff55deea85b2c7aa4da9e4d075f1eed05cbca71aefed0ab" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.16.2/hledger-web-1.16.2.tar.gz"
    sha256 "daa4b68d8491d0a5716ee2ac39520a31bef6a1ae6b36ddc0f531b81616c237ce"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.16.2/hledger-ui-1.16.2.tar.gz"
    sha256 "90f69e1e2f9fa66c535b7f61144b3fb681f1629f313c89d423b4569722224faf"
  end

  def install
    install_cabal_package "hledger", "hledger-web", "hledger-ui", "brick-0.50.1", :using => ["happy", "alex"]
    # help cabal pick a good brick version, https://github.com/Homebrew/homebrew-core/pull/49010#issuecomment-574719702
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-web", "--version"
    system "#{bin}/hledger-ui", "--version"
  end
end
