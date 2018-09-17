require "language/haskell"

class Mighttpd2 < Formula
  include Language::Haskell::Cabal

  desc "HTTP server"
  homepage "https://www.mew.org/~kazu/proj/mighttpd/en/"
  url "https://hackage.haskell.org/package/mighttpd2-3.4.3/mighttpd2-3.4.3.tar.gz"
  sha256 "70dd2845c89917509674a903cdf3b9e54c47eb82a5ae199eb3bf3da56611ca29"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6a29c3f904aee4500991a66dae9b106d946fcc0ac98c3a40d9c3fe9e966bcaa" => :mojave
    sha256 "20b0a49d9442615903fb9532cd2ba070d5936b2cea69b9e5db2ca7be1052c47f" => :high_sierra
    sha256 "5d21c1640f273f3a57c9509c52750da51830fa21c79e6a69015001ed8f6f1f98" => :sierra
    sha256 "53b61f1044d2ef60b1dde3ebe5b5adcce01838c6c962fac14e9ba1e92b123d31" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
