class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/3.0/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.0.3.tar.gz"
  sha256 "84dd0256feefefdf48fe9dbda57e2b56119564027e201846b688add020baabd8"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "ea1bb61a1b1004aef8854f84b1d587b9682313b34aedd231121ef6d21e4aac1b" => :catalina
    sha256 "f3a1939de16fe2e1f54db4aa56805436818b075d692aa36c40d15f3ae2303fbd" => :mojave
    sha256 "32623da3e2d5f30fe7387574d0eb175c4c55d9e37b2e115c1169fb0b097d8a45" => :high_sierra
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
