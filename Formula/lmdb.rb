class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/lmdb/"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.29/openldap-LMDB_0.9.29.tar.bz2"
  sha256 "182e69af99788b445585b8075bbca89ae8101069fbeee25b2756fb9590e833f8"
  license "OLDAP-2.8"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :stable
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e841311d68877f2fb3d1ed488b33ce07c1d4b164babd5bbe6552c4f01765fce1"
    sha256 cellar: :any, big_sur:       "1fe7ed983f30164a0558431649e1b6f86b28dc36660c0ffc215db205f85bbe39"
    sha256 cellar: :any, catalina:      "cb42f85558a8825f775ae80c79a9f5f7ed015d0d4f46f91eba5a4f61474a8b99"
    sha256 cellar: :any, mojave:        "9b1e6d9b6436d526e1798e132d1529366511d18b5c7a8547336cbd3f1683121f"
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
