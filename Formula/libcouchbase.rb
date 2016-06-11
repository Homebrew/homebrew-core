class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "http://docs.couchbase.com/developer/c-2.4/c-intro.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.6.0.tar.gz"
  sha256 "9e4d5a8ccdf8451e5feb8d330c619ab3ecb60e3071cd169780d0a3599f0a2ef6"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "dda84ff0fe8b90fceae5713b983e0a1433c1384b6875871fd8306895dd4b0bc3" => :el_capitan
    sha256 "3ed2ba6493a9bde00922b3ffb8aee816ce59e5af54898a55ec3017b6b84fdc06" => :yosemite
    sha256 "7899e999abf23e9c8b0559858ae80deb2d70eefe3cd7857a9f115aac969b162a" => :mavericks
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
