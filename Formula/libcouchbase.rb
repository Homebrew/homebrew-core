class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/3.0/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.1.0.tar.gz"
  sha256 "281ff774f8f70c359124fc1da4ed92d49223649aaf26d74ebf1a145b0a72f0b6"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 arm64_big_sur: "71fa8fbb2e10e151771ada5a5cc242d6d8055d0215f3b9141620fb39bd53e1a1"
    sha256 big_sur:       "8fec95daad6f595d304d6fcb544c7e8499df9988d2564a0bb2a863ef1cf6dff3"
    sha256 catalina:      "dd30f83a3fb0341b34793b98396db6e5a686819de6f6a7d1c4d40362c92a8b1e"
    sha256 mojave:        "a03cc9667703ab9f7e38e6ec683f80229ee71de0f55b02a5e591c4f65a16d299"
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
