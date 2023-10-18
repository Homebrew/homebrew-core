class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.10.tar.gz"
  sha256 "2c92b8dee1d8d02bab756023ff396cf93bf822400ee68f3a8128912a08348063"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "c27418629da8698371efa91c0cc51879d1073b347e75d56ebed0c29a0a3d5259"
    sha256 arm64_ventura:  "60c9b6f0bc4f8e30f1646574972f32c7251bf81f5ea6fddf31fd0fe75b2c7ff1"
    sha256 arm64_monterey: "c39ce6f6bbb8c9bdb1d8147a3e89b3a3014e6ad82e8b3b4286ce48afe25f056e"
    sha256 sonoma:         "3a51d6ef2b9ab85cf4e59d80ebddf50c94af0b45fa42f2a5a5c8cf4d050631e7"
    sha256 ventura:        "706a021f290769fb56226b1dfb1a1041b125f721d334308e68beaab0b4a756e0"
    sha256 monterey:       "0e2e83f8af7be66683127974c3b5c7c2e28596d6bf69da5b416dd2fa9eb13dc2"
    sha256 x86_64_linux:   "d8423d03c8d6274de2890d17562f472cdd054a62557eb96fe392527f05a6d431"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

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
