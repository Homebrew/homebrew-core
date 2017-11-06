class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/debian/lbdb_0.45.1.tar.xz"
  sha256 "0187bf8330d023a5b156035762d1fc0ec48158287da4d9d6ee4992e2618e91c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "c319443f7dcdd1b43cad1bbc560506819f40fc3da4fb01e217984a7d504256c4" => :high_sierra
    sha256 "f41bef53fd7327f04c6fe272077bf2769f5b6d810a7216f2bec4cc528af707cf" => :sierra
    sha256 "acad68ebfbaead1f00101c2441e53937011b1b7771c3cb1bb07bba1027be337d" => :el_capitan
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
