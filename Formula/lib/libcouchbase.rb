class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.9.tar.gz"
  sha256 "ae1ae8fff068c99e37c26f1399e5ac5c646c55b1d8e3ca78fc909317b4fcb9bc"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "cec5e46ca83e2ccb2ca36365b511b8974d919d5f31168eadea4b6156ddcfe1f4"
    sha256 arm64_ventura:  "737c903a05fb271b7813a88b9e729d2411d71b8bc5a0855034f8b6d2fc5c015b"
    sha256 arm64_monterey: "9cae5d8cc8ce3e080a81b2d17f2d9649188d9745fa9725e318ce2a34f94fa283"
    sha256 arm64_big_sur:  "7bceef0deb0e6cc5c08934e32a1604c62e1d2518b41a6e964671bcfcc00fe64d"
    sha256 sonoma:         "c353961c6b85e6878e88657f7bb946aa8803c0493c01e9187757f961e3d716b8"
    sha256 ventura:        "a57abe1a67642168ce296ebe2b60e737084b8a7c475d1f2a7586b0cbf5f17890"
    sha256 monterey:       "1b342afd260c0c7f33ac6f8acfc8c177fab2c2f15a27d54d564029b5e7b0c892"
    sha256 big_sur:        "976a5e8c7cbc5f202575ed91a23c3e7c4021144a81cb3781c83995d9a83327c2"
    sha256 x86_64_linux:   "eff5613489964873be888b26eb90641cce7192e982279fcfdf4a1b96ddc0a298"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLCB_NO_TESTS=1",
                    "-DLCB_BUILD_LIBEVENT=ON",
                    "-DLCB_BUILD_LIBEV=ON",
                    "-DLCB_BUILD_LIBUV=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "LCB_ERR_CONNECTION_REFUSED",
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end
