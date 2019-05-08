class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.17.tar.gz"
  sha256 "d354ef3a7c56a00e3a83b56fffd499d64ae57d39df0cf8f7f05917d746a9bf49"

  bottle do
    cellar :any_skip_relocation
    sha256 "0eb121db050ab5db96e49341acba87c59c62657339b467eccff3cb9d0b7c902c" => :mojave
    sha256 "cec68da04c7d3f3e3749b48f63d4c3c38c55c2dda778ed4b4c9526e9d61ddf46" => :high_sierra
    sha256 "63ca2b40ae69ff4527553913ca84113d4cac068f26152c55aa22ec327f299e4e" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
