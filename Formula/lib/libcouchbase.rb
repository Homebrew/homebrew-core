class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.19.tar.gz"
  sha256 "2d8a3d1a67e012cc562aa7cf6105def8e23a01930bc92459c43c119a13b3ebc8"
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
    sha256 arm64_tahoe:   "aa5683c71e58254cdbd095d75b6f32191e4d47371120e5fadbf4c92464a01e20"
    sha256 arm64_sequoia: "8f5765d344f5847bc3884713118e73179aece9e142eef76ba4cb3e4a6104be4b"
    sha256 arm64_sonoma:  "704b64c48f9b0f924ac80d2faef28b8625a615a78303495f3f0f3b247a003cb2"
    sha256 sonoma:        "dd346acc949123aa8cad59fc687eba803b85e4493e007c57d417caa5bf906a48"
    sha256 arm64_linux:   "3308bd6c4615bded33865677fad97d56993a2c3f90071181102c36b7b03c4a0c"
    sha256 x86_64_linux:  "704c2c4fa5d26dbc839c5b7ec1e9d6e947822ee4e97352abcd937bcd3b3cd19c"
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
