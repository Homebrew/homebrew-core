class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb_0.47.tar.gz"
  sha256 "cb8ccd75a9cba6fb099f6253c8b85542b800626d7270466236ec95830790ef1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab53c2d73828ebd78c2c84e89f23471b932eb97cca6b14f536642f01addd215a" => :mojave
    sha256 "6b26c9ddcde88f674957eb32f7efbba04f77c1bc994d4b9268681eb07ae0fbfa" => :high_sierra
    sha256 "23c943bd75b4ce851e6b5cf8561b0d7293e503709f6df3e7f79d18d13ea97894" => :sierra
    sha256 "8922d0c2e0905ea7ee43ec738042333b3cfa79558c8529f10d6c26c0c57fbc85" => :el_capitan
  end

  depends_on "abook"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
