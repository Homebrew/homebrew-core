class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.1.2.tar.gz"
  sha256 "ff65a2802988d89553cb0a1207be9a774a35e7cd74fd3865a27e88c9312aa95a"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 arm64_big_sur: "e5a4da7669274a45759ba2a23aea49b2b7d0d8d5de4893e130e95c2f470c856c"
    sha256 big_sur:       "8ad08861cf59a492d28134c0a0b32b71875bee521beb35d3ed8689f6ff180936"
    sha256 catalina:      "b29ecc643e55faf6eb0873efbf1c4d70ec573e43c3c6cde9e323278a2f1030bf"
    sha256 mojave:        "3cc1622c297a382751e14b63f3457436895ad0437161b247c4141fa2d623e43d"
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
