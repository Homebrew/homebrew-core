class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.19.tar.gz"
  sha256 "2d8a3d1a67e012cc562aa7cf6105def8e23a01930bc92459c43c119a13b3ebc8"
  license "Apache-2.0"
  revision 1
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  # github_releases is used here as there have been tags pushed for new
  # releases but without a corresponding GitHub release
  livecheck do
    url :head
    regex(/^?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_golden_gate: "66dee8b4524dbeb7480c6a2c0bdbed525ea51ff0f30fd5cf89a1156c806f6fa3"
    sha256 arm64_tahoe:       "81ec43cd3784d8b0b9644297bfc2741cb69968318bfa6950fde6283c17acad98"
    sha256 arm64_sequoia:     "6028414ffefa002085d3eae1cbcbe7bce8c803ab8b10d43b59914bdfdb080a86"
    sha256 arm64_linux:       "53ef861484823b02c1202dd977295871b935609d6a712ce76593fc2f63faf6b3"
    sha256 x86_64_linux:      "e4d37cafb3e8358d554fb96f4837d1593b55b14fb885e8bb912b130749d53153"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@4"

  conflicts_with "cbc", because: "both install `cbc` binaries"

  allow_network_access! :test

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
