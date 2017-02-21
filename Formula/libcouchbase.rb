class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.7.2.tar.gz"
  sha256 "9f277619e311b53bfa4e5fa00f8fa9647ae3f9544a10e60ecc08249a3a8f252f"

  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "cba376ad2874f6bc503fa8b88da030dff1a1797d086f63c3f5a735e28a002a6b" => :sierra
    sha256 "0f22ba69c7f3e39626ff39d7577be600f5785564a54ff66ac7bb1b264bcf0c81" => :el_capitan
    sha256 "ccf3208241fdc5a101f70668687800ed7b9982138ba2e56affc5bf5cbd2218d5" => :yosemite
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
