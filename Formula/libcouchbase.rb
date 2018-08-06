class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/current/sdk/c/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.9.3.tar.gz"
  sha256 "cd3bba99d5e4935240e502535c3275e0756b480c6bc6746a46fb745d5e7066e4"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "ecab9566813f1ed433dd435f8cf1ab57704b2bf4ad07995cb941ed325500cf48" => :high_sierra
    sha256 "13832f6acf65da844b3aedf6ac01602c55cdc3ca4266fb7d43414da0d0d966ff" => :sierra
    sha256 "9e172a43648d20d7aa7bdd75c8ff6ebfcce3eb0916ae7a6304687584b633fed4" => :el_capitan
  end

  option "with-libev", "Build libev plugin"

  deprecated_option "with-libev-plugin" => "with-libev"

  depends_on "libev" => :optional
  depends_on "libuv" => :optional
  depends_on "libevent"
  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    args = std_cmake_args << "-DLCB_NO_TESTS=1" << "-DLCB_BUILD_LIBEVENT=ON"

    ["libev", "libuv"].each do |dep|
      args << "-DLCB_BUILD_#{dep.upcase}=" + (build.with?(dep) ? "ON" : "OFF")
    end

    mkdir "LCB-BUILD" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
