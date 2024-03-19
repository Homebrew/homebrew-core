class LibcouchbaseAT2 < Formula
  desc "C library for Couchbase"
  homepage "https://docs-archive.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.9.tar.gz"
  sha256 "6f6450121e0208005c17f7f4cdd9258a571bb22183f0bc08f11d75c207d55d0a"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4cfa3dd6c7f0ab5bc3941cbdf47f6adc9811612f7a6e718eab2159831c3aa336"
    sha256 cellar: :any,                 arm64_monterey: "bfd18522083d78ad4ce6b17be69b3503cac74842a4db4c9d86cfdd5c74cd983a"
    sha256 cellar: :any,                 arm64_big_sur:  "ad3efa282b1bd594edce50a633aa0528fbe7c06bf73a677ec8c23a483c351e6f"
    sha256 cellar: :any,                 ventura:        "e6e1e57017bb1976a3d4c7d733ba0d889642e435fc5ad14ac8b33110ebb54504"
    sha256 cellar: :any,                 monterey:       "1b4bfe4e0561283fe40e9fd9b8ac690204322b867ab6d77a2fcf074576514147"
    sha256 cellar: :any,                 big_sur:        "46252be2060367784b5b1e477268b7214dafb582368d2a2d8eea4c849a5ff013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0421fd946a915ee97fe8c0be61661de440daf80c9962d51d1deba23fd4423b2"
  end

  keg_only :versioned_formula

  disable! date: "2024-01-21", because: :deprecated_upstream

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"

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
    assert_match "LCB_ECONNREFUSED",
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end
