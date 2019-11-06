class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.5.tar.gz"
  sha256 "9c4834d4041d2951b3cbefcc3b9ed81a1624e88c30cee08edbe4b44535509c5e"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "10ee13aea694d80723440aaa83a555197b83d1ada575673f73ff763a1e7f2b91" => :catalina
    sha256 "83c032eacaec50f12e1727661ccf460eefcd63b90d6b609c1ad4dba72cfae7f1" => :mojave
    sha256 "c6f861d76830fb6fcb351c9e64b268b93c03788d48f29aece8c7a64c583db368" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DLCB_NO_TESTS=1",
                            "-DLCB_BUILD_LIBEVENT=ON",
                            "-DLCB_BUILD_LIBEV=ON",
                            "-DLCB_BUILD_LIBUV=ON"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
