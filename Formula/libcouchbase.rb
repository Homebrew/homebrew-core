class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.6.4.tar.gz"
  sha256 "ce9d3f1d6509e47fd1d16f9a640d71c9b967d410a429ec45bcdd5e70bdb6f545"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "092fa191d0873a7b3a7e86ad4094d9904dd5b2b14f50a5b34e672626de2e8e99" => :sierra
    sha256 "e5f4901e2f23d20ed7f723c4040f1ab4d3b12c3ba9ab97b85e0d3744671b64ec" => :el_capitan
    sha256 "d82494116e8248bad129abe03eba34ec96f17b97ea1b8c5de22d54fdbef72664" => :yosemite
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
