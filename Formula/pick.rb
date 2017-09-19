class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v1.9.0/pick-1.9.0.tar.gz"
  sha256 "97d3f310eb7de44fbe50ad3451c49d859d607fa14acd0c584aafae97eea65267"

  bottle do
    cellar :any_skip_relocation
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
