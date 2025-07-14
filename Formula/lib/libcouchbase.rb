class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.17.tar.gz"
  sha256 "2d48cac746efc4e01fc5292e9e359989bd666f1ebf8ae9d6bde49ef653a2d6a6"
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
    sha256 arm64_sequoia: "2eaf4f963fb487c966a194881f971919bb7a18f36ada0a95713694bac4639194"
    sha256 arm64_sonoma:  "f40cdc8aa269ee9970df6726ad5a1e8b05cacd46e6f91d8ecfc35b5459b96c68"
    sha256 arm64_ventura: "7e342d22350e123d5a2b203434802144478a80cf1afa7e913911753acf7f2db5"
    sha256 sonoma:        "1f2a5e19a4f98ad3e7a11a79c9f4ea269b2fddb80ed7573f2ffbfbd097312c66"
    sha256 ventura:       "bbe4ab90ff352859b93a7af9d4a00bb1f18cf34b050f502073b9c165bf57789e"
    sha256 arm64_linux:   "87d16cb05c74e3e3dc629ee880762c9f9d29c8635d6de949bc9b86c872e21bfd"
    sha256 x86_64_linux:  "4ee306fd5c2f56816ae0897edfc0d400ab6afcdb5af6be0d97363ba3af8caf40"
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
