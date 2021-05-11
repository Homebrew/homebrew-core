class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.1.3.tar.gz"
  sha256 "b4aed2c3e4d9d9b89d6f87ae0513d7cffbb0afaa5a58684f2e80e805e1367519"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 arm64_big_sur: "6962430ba79b80749d29f905d07b668b1778f12d97a8a4017ba20bcf39b7a891"
    sha256 big_sur:       "2a01ad8826792dc95ecd647239c13c1de851827f479d63bc0db4c989caec61e5"
    sha256 catalina:      "f5c195a992c89a4e0af4b8a7141f64023bde628d8fb1dc265cdba8854804a858"
    sha256 mojave:        "878cc7968ccbe72f2da292b9e40719c0353926c197f41f49f0cc362c45235cc4"
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
