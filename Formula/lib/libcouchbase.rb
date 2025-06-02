class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.16.tar.gz"
  sha256 "99b21ab7a121891397bd4b1fe2310829f2a3bf4682f8d8043f486472e4e95899"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  # github_releases is used here as there have been tags pushed for new
  # releases but without a corresponding GitHub release
  livecheck do
    url :head
    regex(/^?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_sequoia: "f22387d8fc2d447d059732d2f249807d59f75f3fe09673ed3c4f349592703ad6"
    sha256 arm64_sonoma:  "24df7b9539527b16f27f4a0cc3ea480187115b257f6e945c45021e07c5b2dc0c"
    sha256 arm64_ventura: "32f6bda7c4c7c35bd650e665e1889481aa5f1db647733cfe4a35ce675de32743"
    sha256 sonoma:        "55686984ffdbf162e25261968ce5f72000bacdff8798ba965304ebc00b0fd98a"
    sha256 ventura:       "8b37f478b9b1350e59dc8c7a559760b9997b3e0d8fb2a3896eae68d902c288a9"
    sha256 arm64_linux:   "702b5e806e4f4b0c785d7b6d482ccd2cea750e43972e952cc1892264e332ee74"
    sha256 x86_64_linux:  "7892dcddcab195f30d1a6dfc27cc5cd7d8809942f6d17cdfc6eb51f2bf461aff"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

  conflicts_with "cbc", because: "both install `cbc` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLCB_NO_TESTS=1",
                    "-DLCB_BUILD_LIBEVENT=ON",
                    "-DLCB_BUILD_LIBEV=ON",
                    "-DLCB_BUILD_LIBUV=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "LCB_ERR_CONNECTION_REFUSED",
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end
