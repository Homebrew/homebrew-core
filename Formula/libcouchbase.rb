class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.2.tar.gz"
  sha256 "d99ef7ae4e129f839255569a530b8fb5377e265033e5cec056576bdbd9846884"
  license "Apache-2.0"
  head "https://github.com/couchbase/libcouchbase.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "330bcf91ee7f1072b49d9f4659271d1ad218b8f285c9fd7c2fa9f1ad891b6e90"
    sha256 arm64_monterey: "22c4e6e156a17916e584d5c536b367f11225f53e5d9fd7ebec0c32a9cb2541b6"
    sha256 arm64_big_sur:  "c42f0807a6d3a2428d69bc8a14e0a12d731f341c86f6c0fd9b647492607acdc7"
    sha256 ventura:        "3b1e65edb78f078229edfe5325844c01c52136fcb0e3e33922834008070991cb"
    sha256 monterey:       "ac5bed438447e1b9568fa7556f9aba7f4fe7b83914818375aabbde79e7bc1246"
    sha256 big_sur:        "5e71748685a148e7ab08302ffc0e52bf6267c2cf33af3e67be1c8330e0ffb5f8"
    sha256 catalina:       "f7a9b3d187941f8a0ce90478f5aabad88333e6fed21f09590102e2f4d5e5195e"
    sha256 x86_64_linux:   "fcf5f06cd751701fbf7d0032afe7b3d43bec4f2fe741dace104e28971d7a6549"
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
