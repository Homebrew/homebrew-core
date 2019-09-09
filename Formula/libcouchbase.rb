class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.4.tar.gz"
  sha256 "3b1f6c1b4e728d119fc4f9976f296e5930b95a2d94e1b21f407bf35d93a9f40f"
  revision 2
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "d64d1c9f894607fb415fc4dcc6a3427d25b71c02b7221ef8ac5641cce5708f6a" => :mojave
    sha256 "ff48754e705a19a22299d926370d66cab9fd20b5183c0d9b17f9946f02acb98b" => :high_sierra
    sha256 "7fd2d6def666fd2005f97f8da75d1dc34eb7c5098e8d513e097e1a6878458238" => :sierra
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
    system "#{bin}/cbc", "version"
  end
end
