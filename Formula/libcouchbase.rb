class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/current/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.8.4.tar.gz"
  sha256 "22dc8926893790f5d50e4de14526be4c812635e92ff3818c9116775479a1fb0a"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "20554e4bd97779a85437bd1e0c061312acde121d809d1fb5e4cf9003e0b8af96" => :high_sierra
    sha256 "24e5419fd9d565f656d23a40b61cb02c253858bb0cbbe73de5fde1f83b6e3a98" => :sierra
    sha256 "e976e6db9f88797aaf086c193833b0fc21a53b36dcb52b7a5d8e25ff6e0aac7a" => :el_capitan
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
