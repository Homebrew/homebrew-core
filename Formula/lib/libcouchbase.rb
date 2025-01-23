class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.14.tar.gz"
  sha256 "c41c3b187572b76902e9c98c7badee26daa92f5e46da040cc134337db59878a9"
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
    sha256 arm64_sequoia: "48fc696fbd01815b85d6688d708dbda473949d7a21dc3d23a42497a6a7e4cb52"
    sha256 arm64_sonoma:  "0b349c6d887f4d1fa8ce90610958bcc378c25c0680c17d54423a40beef9d03dd"
    sha256 arm64_ventura: "65f2fb66349062c64159ba96df4cd468a790e4fd82cb2b73c7417feeb40a682f"
    sha256 sonoma:        "e1e496fb18f1443ad9c3b6a423a1e492f1af52dbbd25e492d81f442e4255641c"
    sha256 ventura:       "11e68ddd86c4d5d1aa7cd42cac3048b267829747bc86a3f3214e6472b901873f"
    sha256 x86_64_linux:  "6282dfb328aff46e1c25862f1f08406566e1aa92f296de25ccd1880bae41fd5d"
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
