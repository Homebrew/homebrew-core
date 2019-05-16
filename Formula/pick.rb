class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v3.0.1/pick-3.0.1.tar.gz"
  sha256 "668c863751f94ad90e295cf861a80b4d94975e06645f401d7f82525e607c0266"

  bottle do
    cellar :any_skip_relocation
    sha256 "d30bca053dccb474b04c013c9c1bcdc171b4f2aaee2522e58eb00e2064ad72ea" => :mojave
    sha256 "4390712366447f8cdba5dcf58467fc352dbebb3be360c1e885103552afb688f2" => :high_sierra
    sha256 "f2e70f7e7f304b3df2d342646bd8e990aeda284ee25b83d8796dd97b01684083" => :sierra
    sha256 "17a0dd7c4317fda933bbfb311a49a4d2672a45ef35244af543c7d6ef4ac7849a" => :el_capitan
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man
    system "./configure"
    system "make", "install"
  end

  test do
    system "#{bin}/pick", "-v"
  end
end
