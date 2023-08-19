class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.8.tar.gz"
  sha256 "5e29ab6bfc5c1fe4f54450f6285cc36de8fff4bf2d39dd16d17aa47cbb9ff88a"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "47ca51cde8df4d37331a7b8c7244f00db00043801b3be06cbdfffb0acfcf8f28"
    sha256 arm64_monterey: "7038d3b4b1c41131dbe54eb916f7748f08e73ac7a68f9c5d7c0b495255359d15"
    sha256 arm64_big_sur:  "03b994cc189958b2087c83c2383aa015f3b06730d6477465e2dd6751c3079eca"
    sha256 ventura:        "0a9094f4168fe702ae5715c43c9ef476bc2b74fac68084ed4b45a7fc56af0ad6"
    sha256 monterey:       "a2be99e15a99b3bd1eab93d1b691fe90f5833b2697a0270a30d6b78c620e0bdf"
    sha256 big_sur:        "fa4b18d3adef1bd9b8d25ee2d927d74e2d51a7513967c41550df7e43d5dd9247"
    sha256 x86_64_linux:   "2b7124fd40a772ae0b866722a7375e3f3df9a4d832dad533a5a43ed9cbf312ea"
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
