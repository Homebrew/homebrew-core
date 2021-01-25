class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/3.0/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.0.7.tar.gz"
  sha256 "d6b8809db28ae76390cd3b750fc8a38c3625853653269d2cda243782ba8f6c25"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "abef06c0f2824fbb7a2a3733d83c86106de98ad6fab6c4ddc3292ed2c5e73524" => :big_sur
    sha256 "da2a63b8eb5af2bccffef9edc70185ef16b96e836aab25e7b6482f02a017ff4d" => :arm64_big_sur
    sha256 "29ea32998215d2e4a62aa2789ca4b9938734030d3329b2578a983572d4db3ec6" => :catalina
    sha256 "0212c43b10fb0c407ec999710203c4875067ce159221fde24fa49e0ee33a120d" => :mojave
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
