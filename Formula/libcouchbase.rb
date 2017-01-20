class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.7.1.tar.gz"
  sha256 "cd1d219e6cee21a665c61d6949f3c0cdce52526ecea878a3b73feb3ee32d6ab8"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "8d55f50e81932a583636e7012b1f7c9d16957e949e86757a061f10fea4db674e" => :sierra
    sha256 "e435bc360f3e5e6b3eb59ce2db92d1b887c867a6027e832e49aea614dfd92d3f" => :el_capitan
    sha256 "68ed79b82d348b012bd4c06374f81b8066ce65175d90dc7245f969505bc4758c" => :yosemite
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
