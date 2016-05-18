class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "http://docs.couchbase.com/developer/c-2.4/c-intro.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.6.0.tar.gz"
  sha256 "9e4d5a8ccdf8451e5feb8d330c619ab3ecb60e3071cd169780d0a3599f0a2ef6"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "964ed355a4041ec426c76a83e77321c34fa535e9bb7345205d91e0b8f47efe9e" => :el_capitan
    sha256 "f76e55584a397c7311a7b3c53a7ea51df0f4c916db66cf9de45eff20cab95c89" => :yosemite
    sha256 "5b1bfa35752b0480f3edd633179eb69216258595444b60ee3f1595a94ef18f2f" => :mavericks
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
