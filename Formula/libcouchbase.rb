class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.4.tar.gz"
  sha256 "3b1f6c1b4e728d119fc4f9976f296e5930b95a2d94e1b21f407bf35d93a9f40f"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "df23a4a37bb67131056d20fa31403ba60da34016d6137aec2e57058fe4c94e42" => :mojave
    sha256 "d819493bc985858466953e341ffa5cf8c52e31d8a0b0e956d47c4ff5ccf7ac24" => :high_sierra
    sha256 "1c99a71bad7d06d7f85f49325c19ef14956c8b388c93a7bd017e8f03b62f4666" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl"

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
    system "#{bin}/cbc", "version"
  end
end
