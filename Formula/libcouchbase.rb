class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.6.tar.gz"
  sha256 "341d7af60d637c81a4de623168746b699f49a75358aa33d9b1b99dd0a63a7cf3"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "5c6c76de5524a1c134742d55139d3b33b64e010bd075ad3ff712cde4ac1a1427" => :catalina
    sha256 "df795c015e0df35ccb86a87140495fc22d20c3195ee5cc572e4e25190c312905" => :mojave
    sha256 "7e8649078c32b18513cd08d47358c44e0719d0545024267c42582885f7d225b2" => :high_sierra
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
