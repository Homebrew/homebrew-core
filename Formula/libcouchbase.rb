class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.7.7.tar.gz"
  sha256 "2d4a912efde1c96e7361cd374ae18e7e25c892a2d53a55d25602cd97e6d5de3c"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "77518f149bf0b3b34f0bab7b860f7b3e3c8ca59d965e14f8e0058544bb01d368" => :sierra
    sha256 "d1355a0847dd15e79e8ff9ef0c1ce155b5d9d4a9c476c821b948f558ec115bba" => :el_capitan
    sha256 "4bb9769fabe32c2b5ababb2eda6e6c99ed51203fc733d23b07924247ebb87f5e" => :yosemite
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
