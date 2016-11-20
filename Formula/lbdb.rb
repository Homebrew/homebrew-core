class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/debian/lbdb_0.42.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/lbdb/lbdb_0.42.tar.xz"
  sha256 "f7b2ec9f145c77207085af35d1ff87dae3c721848d8de1e97aa328b2f85492fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbcbd8361f996f42c3ebc0ec0b48922323c3f6da4162a82e9eecb3da0689f3fd" => :sierra
    sha256 "c3899f704b90e68f78d020046c6659b67c5f9ec0d90392003e4d98181604c1a4" => :el_capitan
    sha256 "b742d6a7d2c728657f1c49348f2bde4ab232bab8529abaa8eead76d3e6c68414" => :yosemite
  end

  depends_on "abook" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{libexec}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
