class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.7.tar.gz"
  sha256 "91ff6471351a056c446dc29c283eecea8c18da8f4af83b5db469e65482ded7ab"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "ca7cf4634a50e60b8062a30f167378a0dc0dee8769b56d3ff06295ed3820bcbe"
    sha256 arm64_monterey: "3fca4433e31a39784d3592f6202e0e210a808dfb46a8da7b2bf44aa17f2af0cb"
    sha256 arm64_big_sur:  "c31aec7191c949199a7b8288b70a45604570627fa6f920f3407bed25b1ce5bb7"
    sha256 ventura:        "080de5af39760408d6f52ca337a6e7651ffd47071f3af819ca6ec4505be69f87"
    sha256 monterey:       "124142096989cda88b48e1a5b51193381416848e7bc347df0dd2b738198f7036"
    sha256 big_sur:        "a50c866615568fb3041c8539c8e321dc54c6d2e98d27a15d5bf001c2e66eaee3"
    sha256 x86_64_linux:   "7048cc384f786a64bbcd709bb4172cf81c4c7ce58f99ab9b5e8b335c0f579aa6"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

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
