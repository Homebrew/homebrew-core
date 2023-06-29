class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.7.tar.gz"
  sha256 "91ff6471351a056c446dc29c283eecea8c18da8f4af83b5db469e65482ded7ab"
  license "Apache-2.0"
  revision 1
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "300d7c2fa0d9f98b6cffa08f320d2370ba1736df3a2d45d725c26a93f96708be"
    sha256 arm64_monterey: "e74fdba8d3f0d00ed1793e357c35f58bc6dfaa1f1f039010fc8010d573f7f948"
    sha256 arm64_big_sur:  "40efd1c07e2d91a738fcc480462cb6eaab4fa936011ec95f9969a82dd7836901"
    sha256 ventura:        "ac33b4addc0dbadd1c83795dbce10be71fc1cbf375fd84b0195359ae008b6527"
    sha256 monterey:       "f4a2830a86978ae2c64ff83fe54ce010a4a6a9ecc0bd464d2b84013a6b34e76e"
    sha256 big_sur:        "2d2fb55d767c627914474e67ed2c3ef053c077ee10a5d1d321794fd0168091e0"
    sha256 x86_64_linux:   "f196f58278101bf1b8f49a299e29b7cbb021ddb57c73b194d3e3b6be28b19b83"
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
