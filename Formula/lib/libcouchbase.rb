class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.12.tar.gz"
  sha256 "a5db78dc3e51842a85233f66422b3bffe6bd78a6d6ea223c43ef0240d49962cf"
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
    sha256 arm64_sonoma:   "0ffde6d5799d351b615e209633510b278fb118778de121d6a5087950a557039c"
    sha256 arm64_ventura:  "4da283f5643ee2514c6aceeedff4831db3396482cf882a04cde7cffe23ec55f0"
    sha256 arm64_monterey: "a3eaa5aac0eb967ec979f6541a94ee06d90bd2c5c31cd2f6e431c3e9be4777c2"
    sha256 sonoma:         "d0598fabec118ef1fe9130c658842e30aa1d5fed27b17c8cdd1df6c3625659e8"
    sha256 ventura:        "fb91b909b6257f711aa1f84f3ebe5b1f6a0e15c7723a0868788a52336af13473"
    sha256 monterey:       "0271f1056669dacfc8f9d14bd66607c09d22791ae2e3aa0c0e6b455d99cfbc2b"
    sha256 x86_64_linux:   "c8054fd22f7c61a0b5cd07cf86e0f0f4bbde0da15820b108840bdf4afdaea578"
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
