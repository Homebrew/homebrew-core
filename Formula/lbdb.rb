class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/debian/lbdb_0.44.tar.xz"
  sha256 "e58748ef4d065aeee801aa921be07990827d532b7d8c9dfe4a5181a772b7a4f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "864f997197deaed7a00dc5b81e27d0ca821fb26b98a02280dec4cf4ce95accc1" => :sierra
    sha256 "2ce6cb15f4ef3d7bf13a413d97165a07af7ba6a4bc0fd5a0e6b9b882b1ffc032" => :el_capitan
    sha256 "6a5c91d548385fd8e40c8af4eeeea50309d0e9b2d0bc46fa6c3fe30e2099459c" => :yosemite
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
