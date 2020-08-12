class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/lmdb/"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.26/openldap-LMDB_0.9.26.tar.bz2"
  sha256 "cda7a06f615dbd7d35987e83df689190d3e9f263190f2f1e36b70357786351f7"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  bottle do
    cellar :any
    sha256 "22dcd49d0d1027f6acef65aeb8f08422f9482daecf4c75b1add02f5368bfd96e" => :catalina
    sha256 "2e9006940427302ed31c4972d47a998be797c669e2d75056107fcf28974f43e7" => :mojave
    sha256 "445091428bfb6ca3712290c3484dcba219a6e4ab935829050e0c4caf0bc7b1b3" => :high_sierra
  end

  def install
    cd "libraries/liblmdb" do
      system "make", "SOEXT=.dylib"
      system "make", "install", "SOEXT=.dylib", "prefix=#{prefix}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")
  end
end
