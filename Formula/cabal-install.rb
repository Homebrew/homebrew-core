class CabalInstall < Formula
  desc "Command-line interface for Cabal and Hackage"
  homepage "https://www.haskell.org/cabal/"
  revision 2
  head "https://github.com/haskell/cabal.git", :branch => "1.24"

  stable do
    if MacOS.version >= :sierra
      url "https://github.com/haskell/cabal.git",
          :branch => "1.24",
          :revision => "51ff8b66468977dcccb81d19ac2d42ee27c9ccd1"
      version "1.24.0.0"
    else
      url "https://hackage.haskell.org/package/cabal-install-1.24.0.0/cabal-install-1.24.0.0.tar.gz"
      sha256 "d840ecfd0a95a96e956b57fb2f3e9c81d9fc160e1fd0ea350b0d37d169d9e87e"

      # disables haddock for hackage-security
      patch :p2 do
        url "https://github.com/haskell/cabal/commit/9441fe.patch"
        sha256 "5506d46507f38c72270efc4bb301a85799a7710804e033eaef7434668a012c5e"
      end
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "874a605b03477af53f483fdb962f20905521d1e3f2d166536c54d260c7c24af5" => :sierra
    sha256 "a19398985f66a962025006ed3463ffa5e4f93fd740878a6400f25b1c63d248e0" => :el_capitan
    sha256 "bc3df0adff1bac34e14d65d55521df0e0f5b40ca43d969da4058fe4db3cc6e86" => :yosemite
  end

  depends_on "ghc"

  fails_with :clang if MacOS.version <= :lion # Same as ghc.rb

  def install
    cd "cabal-install" if MacOS.version >= :sierra || build.head?
    system "sh", "bootstrap.sh", "--sandbox"
    bin.install ".cabal-sandbox/bin/cabal"
    bash_completion.install "bash-completion/cabal"
  end

  test do
    system "#{bin}/cabal", "--config-file=#{testpath}/config", "info", "cabal"
  end
end
