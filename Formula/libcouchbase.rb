class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.7.5.tar.gz"
  sha256 "cbc07429df646bc2422b726506441204f5c3063f5b57c25915915a4ae9e848d2"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "afe9e241e7c3019f764534a55c7abdeee9a9f164b7bec6764ef1b35d8c9ddf72" => :sierra
    sha256 "fbd85333510678e1eef359562efb4ed043ca98167c91f06eea8dadf9f74fd92b" => :el_capitan
    sha256 "2143d92fa60ac873525b448f31d5feb39f6ebc2dc9c967e60bef8abc9ebe73e9" => :yosemite
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
