class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/3.0/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.0.6.tar.gz"
  sha256 "5e5879207cfe655759ba12378be6e5500546a52aae06ce446d86e639c3a40ab9"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "95eeab4f484fdf7747a2c8842b80078746d213c0906bf792d8e613b2e2fbe8a4" => :catalina
    sha256 "a29066942f089d82959fb3f7d4fac5d5aecf213991bf0ea575e9a51cb735a22d" => :mojave
    sha256 "ddd799932aeb56833fbb59c035e1413a2ba2b625f59fec85386623bd0a6fd80f" => :high_sierra
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
