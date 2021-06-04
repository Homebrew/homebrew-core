class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.1.3.tar.gz"
  sha256 "b4aed2c3e4d9d9b89d6f87ae0513d7cffbb0afaa5a58684f2e80e805e1367519"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 arm64_big_sur: "72815d6444601b6ffb4961321669a6c806e1efce92c76e6f14a3773eb7c17c30"
    sha256 big_sur:       "53e18993450e62ce593f0562e954dd62157cf82f2279c44b984fb13a34cf76ac"
    sha256 catalina:      "1a7d3d96544331a8e43df4400a8e4bd4451350d7a0fe6dcb91fae05bf41ca50c"
    sha256 mojave:        "d457d270cd478f5a52c33b2de47041033a13da57d618febc98d8c0c152392bfc"
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
