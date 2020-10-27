class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/lmdb/"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.26/openldap-LMDB_0.9.26.tar.bz2"
  sha256 "cda7a06f615dbd7d35987e83df689190d3e9f263190f2f1e36b70357786351f7"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :head
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "83f3500e1b1d6b1526149c0a71bd85c46467544ad9810e13e1056fd259ff72af" => :catalina
    sha256 "136b38523a78e369219c564aabc58246a658e7a6de772d2933d2f714184bac44" => :mojave
    sha256 "1246ede7c51091638b608546507337230ae428f58f83be3c45ab04b261a201c1" => :high_sierra
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
