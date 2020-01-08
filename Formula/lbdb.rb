class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb_0.48.1.tar.gz"
  sha256 "b0cbc68abeb70be779b234f736dd7eb14bf3f7cd1a2ea41e636de1949da025bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "838c923b4c208ace533b34a2eba8b78c348bd3cc89fdbdb36c42a45b7e592f52" => :catalina
    sha256 "a02ea4967e809c9254dac7726c7ee9365e1ba99a8eef68fe6dfd4de34d2fa5af" => :mojave
    sha256 "0e5c126d7cb1c5ed3211ee1758a388597b00f32c3fb22c0420919e3667371ee2" => :high_sierra
    sha256 "d22e5b8b66ab51d8c6d324330178284c9b35e3ef17362724089e1e979e9c05d4" => :sierra
  end

  depends_on "abook"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    ver = version.to_s.split(".")
    assert_match "#{ver[0]}.#{ver[1]}", shell_output("#{bin}/lbdbq -v")
  end
end
