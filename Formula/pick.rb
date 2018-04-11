class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v2.0.2/pick-2.0.2.tar.gz"
  sha256 "f2b43aaa540ad3ff05a256a531c2f47d3d95145b82c1d1b0d62dfb40d793d385"

  bottle do
    cellar :any_skip_relocation
    sha256 "b929f5739b2bd0ab8df7ea5d941899fec265bc576fcc1660b3e16a3dc95a1f3a" => :high_sierra
    sha256 "1633f9112356cfa6a70f6aca24e38f20e371a109234a7381993bb44b1a9caa9f" => :sierra
    sha256 "29fe7c34922662f10555594fb3f817863d872aea289d51ddc2f98ba8921e2674" => :el_capitan
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
