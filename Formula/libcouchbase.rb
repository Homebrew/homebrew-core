class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "http://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.6.2.tar.gz"
  sha256 "28f9218aea0bd0b390bb8129aa6ac2724b7444c0e0c62e21df8d3aabdb896b18"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "d88fb37337a0375c23efdc9b82a52d97d9d44747ebe474876f7dcd19c92e9a11" => :el_capitan
    sha256 "0a526ab23fc9531c31ebe0b3f03002fa4619465512a2499f01d19ac4d5893017" => :yosemite
    sha256 "addbf3bd0a96c289cb2ac426970f708908d73e4a04ba1a8bd1d47441aa6b959a" => :mavericks
  end

  option :universal
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
    if build.universal?
      args << "-DLCB_UNIVERSAL_BINARY=1"
      ENV.universal_binary
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
