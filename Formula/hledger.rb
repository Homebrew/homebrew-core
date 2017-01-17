require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.0.1/hledger-1.0.1.tar.gz"
  sha256 "835de42bebfbf55a53714c24ea4df31b625ee12f0766aa83aa552ba6c39b7104"

  bottle do
    cellar :any_skip_relocation
    sha256 "db714718300ac7873787c3c405bcd722fe4093e81475241eaf1ff399e14ba940" => :sierra
    sha256 "e10af73376c70c9bf1c90b0de079e00e38ea8a0fa0354650654a5888e61003ef" => :el_capitan
    sha256 "15b246c623035ccde527accae73e7a274d77f02298df3db80ace83db98374bf7" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    system "#{bin}/hledger", "test"
  end
end
