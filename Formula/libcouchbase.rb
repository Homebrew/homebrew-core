class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.6.3.tar.gz"
  sha256 "4010a10d8204ce4bb0b05b3cc24a727f88e303633639b3d9649d4d2ab03ebf6b"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "88a39268a7dfdeaf7973125e3af8e7ece9cbf1ad4c9b1c0de45d6f9cb72d89a4" => :sierra
    sha256 "e6e4b35d80c337d7f5720a9f3ba3a8aa7957a5459a03c9c71eb682a811a15f6d" => :el_capitan
    sha256 "47cb944a620fc6f02c06bed5697710519353f08d084addf55d907f5ace54cec4" => :yosemite
    sha256 "cd90717de6c67c6ca8e475389b1baef57f2555a2e193805b8f43960e586ade18" => :mavericks
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
