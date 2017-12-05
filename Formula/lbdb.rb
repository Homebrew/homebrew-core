class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/debian/lbdb_0.45.3.tar.xz"
  sha256 "526dc5fd574aaf456cfd5d3b15b797b01753f64660e43c7bc4e61f7eeae07795"

  bottle do
    cellar :any_skip_relocation
    sha256 "8534e8877459b70cba8909e56e86e5e5941b925fce778f8b129eb0d665fe0e46" => :high_sierra
    sha256 "f3f84de13606899c190dd2088e5c3c368ebe4114f345fb2c0ea89675da9edf2d" => :sierra
    sha256 "da46a60964f9a2dfe184dfb4dc21c07d1b5eb680819a26459319b9c0e8cff295" => :el_capitan
  end

  depends_on "abook" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
