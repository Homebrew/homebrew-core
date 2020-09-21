class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/3.0/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.0.5.tar.gz"
  sha256 "41bc40922cbd784d1d46374e921e5b8dcaa4daf8b81802810b43a354407c1eb2"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "390701dc52468061f893e9711884f6847764d0ad6d6d141d012775fc41499841" => :catalina
    sha256 "6fe952f6cecd138dc4f4d84cccd913d15c6855f0f0d9fb0b6dbe054f9ccf3fa5" => :mojave
    sha256 "244210b83c9eda35f870ac60206f2d6c3118790430e15e0debc2bf0e9be98b3e" => :high_sierra
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
