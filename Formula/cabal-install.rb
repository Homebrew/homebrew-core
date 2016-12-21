class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  url "https://hackage.haskell.org/package/cabal-install-1.24.0.2/cabal-install-1.24.0.2.tar.gz"
  sha256 "2ac8819238a0e57fff9c3c857e97b8705b1b5fef2e46cd2829e85d96e2a00fe0"
  revision 1
  head "https://github.com/haskell/cabal.git", :branch => "1.24"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1f1864de10d275581a64f8d4f65691bb40f344ab90d0ba6276228b13a5585a0" => :sierra
    sha256 "11791fdd49201834a6c35b31f11f711a0d329a1f95bb4e9810513f3bde30dffd" => :el_capitan
    sha256 "4788ddeddaccbfb926bec03db463e5041221a07d78b927b6d38ae881bd567be2" => :yosemite
  end

  depends_on "ghc"

  fails_with :clang if MacOS.version <= :lion # Same as ghc.rb

  def install
    cd "cabal-install" if build.head?

    # Remove EXTRA_CONFIGURE_OPTS once hackage-security > 0.5.2.2 is released
    # https://github.com/well-typed/hackage-security/pull/177
    system "sh", "-c", "EXTRA_CONFIGURE_OPTS=--allow-newer=directory ./bootstrap.sh --sandbox"

    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
