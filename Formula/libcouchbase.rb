class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.7.5.tar.gz"
  sha256 "cbc07429df646bc2422b726506441204f5c3063f5b57c25915915a4ae9e848d2"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "42ace37908f48aaee48ebaac970ca1a2bb41dcb76e17912cd704d6868e382480" => :sierra
    sha256 "bb43818050ed2588c1630b298f838157a3f4e2bca1f547da9aec68aa1c090512" => :el_capitan
    sha256 "af79e1ce62fd3002a99a5111353e84aea5338c3334d05f3e251a8f601ae44c24" => :yosemite
  end

  option "with-libev", "Build libev plugin"
  option "without-libevent", "Do not build libevent plugin"

  deprecated_option "with-libev-plugin" => "with-libev"
  deprecated_option "without-libevent-plugin" => "without-libevent"

  depends_on "libev" => :optional
  depends_on "libuv" => :optional
  depends_on "libevent" => :recommended
  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DLCB_NO_TESTS=1"

    ["libev", "libevent", "libuv"].each do |dep|
      args << "-DLCB_BUILD_#{dep.upcase}=" + (build.with?(dep) ? "ON" : "OFF")
    end
    if build.without?("libev") && build.without?("libuv") && build.without?("libevent")
      args << "-DLCB_NO_PLUGINS=1"
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
