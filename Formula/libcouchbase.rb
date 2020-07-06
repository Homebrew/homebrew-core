class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/3.0/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.0.2.tar.gz"
  sha256 "901c1490c2f5627b969fe88eb0216576ba22bb6928844ee4283e8e0c6acee721"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "715d52f1da3bf6a1a14057170bb41aacd2469a98fb86bb8c75df0966ddb3c42a" => :catalina
    sha256 "fdb0245134a07c6db0ab52ccd731f9b878e8f6ad332276fe2b2dcb7e33246952" => :mojave
    sha256 "7dd7315f91680dc57b0306011f4b89672856992896764e02273ce303430fb237" => :high_sierra
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
    assert_match /LCB_ERR_CONNECTION_REFUSED/,
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end
