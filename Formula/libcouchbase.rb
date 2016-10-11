class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.6.3.tar.gz"
  sha256 "4010a10d8204ce4bb0b05b3cc24a727f88e303633639b3d9649d4d2ab03ebf6b"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "f1530e96a339f85acd42bafedb179a2456f8c2f9b57c43a759eee9a188032ec0" => :sierra
    sha256 "4093f89487c3a6f2d1847f71a2a1033f0b49e00c6ca59b416773df5bbd3e7bdf" => :el_capitan
    sha256 "65f0260b24a4243ecc4db096818670c627ba0faf1dba183de2a3ff9e86616852" => :yosemite
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
