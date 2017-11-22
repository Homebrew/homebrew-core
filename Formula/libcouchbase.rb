class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.8.3.tar.gz"
  sha256 "d4b33495c4cb974b135d052b712bd0253230caec008d27a94ba3def095e8db69"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "ff9dea1a6bb1b39a57e2a94316ad70f5535ae33e7906d578b27496ca6890f3e8" => :high_sierra
    sha256 "fd257896bd317270317f5730a4664cd04a4978c52964bbfdb4b0be0a86f44d96" => :sierra
    sha256 "c58fdb8a5266e72ac31323ad564acc378c3f12c7f11dc64c45dab640691a1d54" => :el_capitan
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
