class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v2.0.2/pick-2.0.2.tar.gz"
  sha256 "f2b43aaa540ad3ff05a256a531c2f47d3d95145b82c1d1b0d62dfb40d793d385"

  bottle do
    cellar :any_skip_relocation
    sha256 "d30bca053dccb474b04c013c9c1bcdc171b4f2aaee2522e58eb00e2064ad72ea" => :mojave
    sha256 "4390712366447f8cdba5dcf58467fc352dbebb3be360c1e885103552afb688f2" => :high_sierra
    sha256 "f2e70f7e7f304b3df2d342646bd8e990aeda284ee25b83d8796dd97b01684083" => :sierra
    sha256 "17a0dd7c4317fda933bbfb311a49a4d2672a45ef35244af543c7d6ef4ac7849a" => :el_capitan
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
