class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/3.0/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.0.2.tar.gz"
  sha256 "901c1490c2f5627b969fe88eb0216576ba22bb6928844ee4283e8e0c6acee721"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "c429415d4362d9ab789bef88dbfa1fe3806cd2dac163cac40dcad20981347e15" => :catalina
    sha256 "d1d611e4b4d781b21ba823bf0150dd4b13ef66282f58d70cd8f9eb9df8d8f888" => :mojave
    sha256 "b7c5ffe16735dcc77adea3e06aba2d59d3497d5f0d897985e15ee0bfec29e36e" => :high_sierra
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
