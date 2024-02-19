class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/current/hello-world/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-3.3.10.tar.gz"
  sha256 "2c92b8dee1d8d02bab756023ff396cf93bf822400ee68f3a8128912a08348063"
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
    rebuild 1
    sha256 arm64_sonoma:   "ea16c5dda4d1564ea45ab75344652563a12b311ee296caba9510fc4656dd1b44"
    sha256 arm64_ventura:  "e772b3f61a9890735d74aa2f3055e4b2dfc2f3bcc4920b60cc151fd9a8083b3b"
    sha256 arm64_monterey: "ae830c501ae8ca238b1ca444b91ef60dea96b41da97908b669df45217482d2d7"
    sha256 sonoma:         "574aca48d57a765c5113b8174cde1cf14c2a03952ad935341d1ccb9326c34032"
    sha256 ventura:        "1bcd5ede6ca3e46d67f89be8c43c2877c5ec2fd8451ff799ac2a13cdd45eeaf6"
    sha256 monterey:       "42f9623fb7c91e0b7024f0c0c532b89ccf51add64e2c7730bd1db9a1f683bc3e"
    sha256 x86_64_linux:   "a18cb900f1f7c73e56ce2767f2a85ba32b417faa4c3584a0c8798b1e96864c6b"
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
