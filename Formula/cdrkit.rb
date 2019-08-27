class Cdrkit < Formula
  desc "Collection of computer programs for CD and DVD authoring"
  homepage "https://en.wikipedia.org/wiki/Cdrkit"
  url "https://github.com/sidneys/cdrkit/archive/v2.0.0.tar.gz"
  sha256 "bf07b0e011532c1f96bbab71efe75537c5ec1614fd9636ce551fcaf56b03579c"
  head "https://github.com/sidneys/cdrkit.git"

  depends_on "cmake" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "genisoimage 1.1.11 (Darwin)", shell_output("#{bin}/genisoimage --version")
  end
end
