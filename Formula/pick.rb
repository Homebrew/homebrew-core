class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v1.6.0/pick-1.6.0.tar.gz"
  sha256 "d034fd75256ccb3e8c6523196ac250b44b18170a6594944ed6d23d1bcabfae6a"

  bottle do
    cellar :any_skip_relocation
    sha256 "beedb620ec9a054745e1ae71bf8d470fc9eb073766f651f7a72fbdc4791b725f" => :sierra
    sha256 "ba52a5b92d50b2f93f696a25471db648b158bce47477c2c9cfddf0e334159633" => :el_capitan
    sha256 "473f1dbdd02109b15ffcc1affb34331b1e6a6765dd2f4cd5fb708326f0392389" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pick", "-v"
  end
end
