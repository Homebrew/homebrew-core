class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.1.tar.gz"
  sha256 "5513cb35aa8e8c0eeeee01843daf932aa6d975e5a3e6a05efc5e3450ff0259af"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "e6ed571e02e25a9d81b7201503ad1028d3434a91b6b3dfc1df80e7462518a16e"
    sha256 arm64_big_sur:  "cd320a010e3db462b09826fe92c2498148dca4ae33962ae0a123f88cf100c6af"
    sha256 monterey:       "918f7b8a4fc83f66a9e022155509a18bfaa899541491a526534ce54fd95d51c6"
    sha256 big_sur:        "f5c56b4d5a99ad098b9e5a2c5d613a40fe965fc2f5f6f47f2f461d45391dd1a1"
    sha256 catalina:       "c5c2432e15b1573b9efde639f4e08a275e43d5b0f77c2177aa33ae3b0ee95a32"
    sha256 x86_64_linux:   "f363cbe4b43e6b7f753fdebad1497880563d9ecda3928f0058eac7d039be2847"
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
    assert_match "LCB_ERR_CONNECTION_REFUSED",
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end
