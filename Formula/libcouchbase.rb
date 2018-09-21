class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/current/sdk/c/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.9.5.tar.gz"
  sha256 "2d8c1df339066619e2491ccca5d50164190abfacb38cab24a3190e73649707bd"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "a2c66ef912b55575c07ed14b9006c28fdc44ca0b288051709b7a6df672fe1eb4" => :mojave
    sha256 "ecab9566813f1ed433dd435f8cf1ab57704b2bf4ad07995cb941ed325500cf48" => :high_sierra
    sha256 "13832f6acf65da844b3aedf6ac01602c55cdc3ca4266fb7d43414da0d0d966ff" => :sierra
    sha256 "9e172a43648d20d7aa7bdd75c8ff6ebfcce3eb0916ae7a6304687584b633fed4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DLCB_NO_TESTS=1",
                            "-DLCB_BUILD_LIBEVENT=ON",
                            "-DLCB_BUILD_LIBEV=OFF",
                            "-DLCB_BUILD_LIBUV=OFF"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
