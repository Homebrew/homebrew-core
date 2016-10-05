class Pbrt < Formula
  desc "Physically based rendering"
  homepage "http://pbrt.org/"
  url "https://github.com/mmp/pbrt-v2/archive/2.0.342.tar.gz"
  sha256 "397941435d4b217cd4a4adaca12ab6add9a960d46984972f259789d1462fb6d5"

  bottle do
    cellar :any
    sha256 "7dfc107dbc633a3273433e7f763ffaf743660281c223e8ef27816836bd6dfa79" => :sierra
    sha256 "77510b79395468971a567029052265fd03e9c9eeaf4e6056d1a225d7ade5d718" => :el_capitan
    sha256 "ddfc01d16de04891db883377f509768768e374f2a8fab1536f5487fe559d707b" => :yosemite
    sha256 "ac424bf47ea119d977b7e2f2a0bfca9a994838437cd9c1f189a71eed83b816d1" => :mavericks
  end

  depends_on "openexr"
  depends_on "flex"

  def install
    system "make", "-C", "src"
    prefix.install "src/bin"
  end
end
