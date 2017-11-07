class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v2.0.0/pick-2.0.0.tar.gz"
  sha256 "0e87141b9cca7c31d4d77c87a7c0582e316f40f9076444c7c6e87a791f1ae80b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f06d7c346a1858d337c4d54851254aaee161d8f84de2b98aafa7a6dec81bec0d" => :high_sierra
    sha256 "0cede3fd5fddad1438de83e65faae8a0e93ce7059c73543d98a9f877224d5a38" => :sierra
    sha256 "cff85b8b26aee2d3cbb44e38a85173245eefc0084490bfc13ba9c91808896364" => :el_capitan
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
