class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.15.tar.gz"
  sha256 "68ea4d39387b1c2af0305be30bf60b88126cb714e84b441c57ba2b3e81ca2626"
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
    sha256 arm64_sequoia: "b0f45a14e9bb074bab8038ec75d5ea4fe6d4d203e85b54619da3d69e0ef6a313"
    sha256 arm64_sonoma:  "62879676667a388eb5ef7abe6a8fbb4095841df3441074d0b53c4ac931467c05"
    sha256 arm64_ventura: "dea2be789f4fce7680b8a62fb0a60224f3ab06810a4a803e696d3c806ac02490"
    sha256 sonoma:        "bd03bb25ad1acfd696e23ec686072d75e06ed47ba85b98351ec388fd92963400"
    sha256 ventura:       "22845abcd8b1c14325329560cb4adb2508dfad518751253a37e4905274ede095"
    sha256 arm64_linux:   "27e661f832c9a0f7de8a33a96751a5499e85969c913c90796eef54198540ff2e"
    sha256 x86_64_linux:  "0d9872703a7cc16316688c9a3768edff6fee8db561a3ae752e442179817c399c"
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
