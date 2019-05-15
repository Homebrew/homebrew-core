class Pbrt < Formula
  desc "Physically based rendering"
  homepage "https://pbrt.org/"
  url "https://github.com/mmp/pbrt-v2/archive/2.0.342.tar.gz"
  sha256 "397941435d4b217cd4a4adaca12ab6add9a960d46984972f259789d1462fb6d5"
  revision 2

  bottle do
    cellar :any
    sha256 "cb7db9ee459b829416669ed7a714523e2a5f91f507b80d1109224e8b7ebb4727" => :mojave
    sha256 "11eedcb0ab187fcc29ae87501553341a13a875dc9b2d3c87be61c67ad38b5941" => :high_sierra
    sha256 "71cc74c9781e4f2008f397703a90fdc2cb1d655ef4bd9c66e1b6399c26cdcd28" => :sierra
  end

  depends_on "flex"
  depends_on "openexr"

  def install
    system "make", "-C", "src"
    prefix.install "src/bin"
  end

  test do
    system "#{bin}/pbrt", "--version"
  end
end
