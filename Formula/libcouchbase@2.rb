class LibcouchbaseAT2 < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.7.tar.gz"
  sha256 "bbee97ef2394f275b8cd4b9b940010566a2d34d4754ba3532a7fca3d94029b75"
  bottle do
    sha256 "b2069cc7be17f5bf8508b8262d5dee0b1948758f8d65eaab3ded9baad902100d" => :catalina
    sha256 "70cdc91856c6c9c24e0e34ba59afffdb42fbe6c95cb0e3c2ff09f22d266b4f6d" => :mojave
    sha256 "7dc8d8f3258f267952e2e0bf87004d650a88a7bf1ed64bbaf56934d42271ad56" => :high_sierra
  end

  keg_only :versioned_formula

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
    assert_match /LCB_ECONNREFUSED/,
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end
