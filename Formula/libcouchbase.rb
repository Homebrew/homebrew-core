class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/3.0/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.0.7.tar.gz"
  sha256 "d6b8809db28ae76390cd3b750fc8a38c3625853653269d2cda243782ba8f6c25"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "59e24917012c238b11f15e4c42fbabad93cefc82c738f643864beeeb29bf2f9a" => :big_sur
    sha256 "cac82c27a7b0fffddaa3d5ff60fdd13a8436f3e5870c39fc74355fb6afc166fa" => :catalina
    sha256 "0b065a2160a48ee2f9d5085180842dbc27976152ed503b24af93abfba500cd9f" => :mojave
    sha256 "01935cfa1eed4ca89fa1247a501093d647f9a88749c4209976f5babdc6f3c677" => :high_sierra
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
