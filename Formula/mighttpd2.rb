require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.3/mighttpd2-3.4.3.tar.gz"
  sha256 "70dd2845c89917509674a903cdf3b9e54c47eb82a5ae199eb3bf3da56611ca29"

  bottle do
    cellar :any_skip_relocation
    sha256 "e29221e4447f87a83fb9853247db324f14e4621048ac5a7d8aefe3f864c7df55" => :high_sierra
    sha256 "ddbaad5489107e4eaa59215c1158e97a1ae6b70dfbed71fb843c001f4ea5aeac" => :sierra
    sha256 "5d90e9953d3fda3d9777a8b3451c48b7aabeaa6b3e162a2771859c3683a74f2c" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
