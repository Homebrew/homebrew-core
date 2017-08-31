class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.8.0.tar.gz"
  sha256 "862ed3fd01938d872782f1a96b318d517c3015ef1b1183cdcf5b2098a1d4705b"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "9371839c4f7756e6ee7bea6f4bffbdbb246be66262cb7ed5a8854fcf91b39020" => :sierra
    sha256 "ad3b2e9a39ba095edff470175371092fc3d990a1d5bafc8f376c5604cd80af16" => :el_capitan
    sha256 "7d29ae128f2b10a187efc54b0db42f921c8d0ed63999e375618d7626a529af75" => :yosemite
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
