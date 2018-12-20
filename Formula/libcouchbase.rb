class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.3.tar.gz"
  sha256 "1cc6c6a41dd1c92e26830e227b42c705bf6c4005342fb609d60fe2b63a5c5aa6"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "713b002219e8982e08d95afde3aebf9d3c8795d117851121078e6aff031e6370" => :mojave
    sha256 "06b4d45bf1788071f5ee30358dbbfd1a7217e2a23bc84810714e8cb87c1270f2" => :high_sierra
    sha256 "6b1c1f546afc5d4d65dc8d1685de6410655414f3810280af3c85b9f31e0a9470" => :sierra
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
