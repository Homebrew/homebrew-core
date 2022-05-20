class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.0.tar.gz"
  sha256 "5b70ccc53bb5c61ed2aa2ed5f495c0fdb474e3c4cc1b5fbbd94f6a1b96776bd2"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "d1dd5618afd54e294a06f56cf9611c79829df4fc5ff6eb2c5a4e52baf0978288"
    sha256 arm64_big_sur:  "e3716b38221b6ffe23acdd4008c97cdd4197fd8d8df6da5bdce89fee20889da4"
    sha256 monterey:       "df746ac669a8c63f3bf0df08c80aca4544daca0b59c9ff7028d322df0181bbe1"
    sha256 big_sur:        "3a77bea5f9a3b4261ed9f5495892011a2428f7c0fd0aeacf2627b92c25f33e3d"
    sha256 catalina:       "f38e34f4f2c412a7bfe02a119364b308b186caab95675562114502038e61f973"
    sha256 x86_64_linux:   "98970a6c121e6a8e5e8041b9a1619abfb4e1de1cba1ca10fd009dd4ef6ba36ea"
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
