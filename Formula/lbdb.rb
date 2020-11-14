class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb_0.49.tar.gz"
  sha256 "f565b64a0bc8edb2a5a273e305d5cdecd9053d834fb96f6b2b2f353c99c3c887"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

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
    assert_match version.major_minor.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
