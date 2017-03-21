class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"

  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.7.3.tar.gz"
  sha256 "6cac181256d1bad5afc5ac54396772b01c4c686a243ea3b3958fc844cefcfc7d"

  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "851cc0834a76f63828a8c1ea02dde3c55c6f993d1234cd1addf9f7ae315871af" => :sierra
    sha256 "89acad2bb61ff5be98d849139929f705a09cd1cd1d79e67cda21c1a44229ca97" => :el_capitan
    sha256 "de03a582adc349ec2cccf0f5a56c420068c6577d59e930505699dc7dc10eafe3" => :yosemite
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
