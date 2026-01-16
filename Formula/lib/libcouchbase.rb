class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.18.tar.gz"
  sha256 "2c565850f05b71dd3876fa0dfcab71ec45488ec9d949a7460070930e016c378d"
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
    sha256 arm64_tahoe:   "f7e83031c6d40e0df4650245a4380fe5b8237d908128f4c729839983f36a6e24"
    sha256 arm64_sequoia: "2248b6e4b0823e55911e61efe8de53a92bb697ecdf4c0a8e39e2ed0cdc43d27f"
    sha256 arm64_sonoma:  "38419a8f4a9205ece6d69df6db95011921b39cffd7a1bc313a2dd625d7d571b8"
    sha256 arm64_ventura: "69e9d0a806632a5fd29e0304eae5a7af048358a3543d4f8092eee7ab812320f6"
    sha256 sonoma:        "67279b1cee297651fad2f9f3a898ccbc878112ff0a279ddd20ff02e70dd59e80"
    sha256 ventura:       "909717b058dc6cb16245d94bfd28669f369af6c57cf0acc493fc00e766a355d1"
    sha256 arm64_linux:   "4d67b5d13b9185a0606d2809812add342ee0a3ff765b100adda2f6a50899b68a"
    sha256 x86_64_linux:  "857eae4e85d993266775356d4f662de723976127f922c62200f7257da7539453"
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
