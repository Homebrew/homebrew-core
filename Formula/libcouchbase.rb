class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.2.2.tar.gz"
  sha256 "a7977e9a3f81c01542296fb7a8cdecb166ade89b2a81806f9d5cec07f0dc194a"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 arm64_big_sur: "b67835503d1cc50b9d07d5c6793e33a28faa44f756edc4dd5ad031812d785d4a"
    sha256 big_sur:       "4dc26740d2f96a5e71706bd5d7c2b5bb75c4b13043ea1708f66ac069b385af35"
    sha256 catalina:      "748fd206b182f128d8c2b2ea8b49aa1fcb04d781474adbc8270897db630ba755"
    sha256 mojave:        "d60ad634b1751766750e843ca38ae355c44fa581713846607878378bb62de069"
    sha256 x86_64_linux:  "0c0419c9f112cf286895984bc48fb0c8bfbf0ad49797bea16742880f8dac2e47"
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
