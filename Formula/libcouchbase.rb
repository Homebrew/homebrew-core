class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"

  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.7.3.tar.gz"
  sha256 "6cac181256d1bad5afc5ac54396772b01c4c686a243ea3b3958fc844cefcfc7d"

  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "2a59d79bc2ded621e1ae0d6817d487897819cdb613b992b85a5822aa5d05f352" => :sierra
    sha256 "defd3b7ac27e179d59678a77d8986b12b04bdd706dd60e9b8b5915d9775ca065" => :el_capitan
    sha256 "96ffc749104a6c20f61c9b9d3f4963824c95ac12b32327b9f7f292c349e932e3" => :yosemite
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
