class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.7.0.tar.gz"
  sha256 "c0ce74c5ede1ecdb49a9f2eab174ab90825263e659f900c9d017a7b7f58c2206"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "f3b4ce4f85c62a6ab91f3c4ea43a55dd6f92f0e2e5d44528ed8d253c44e73987" => :sierra
    sha256 "761ca378aa3167d5c1bf70f47c742db6d5e7ed766524a2187e62afa250e8029f" => :el_capitan
    sha256 "afb432710eccaff6794130e494dd4675ec95669eae580bf8a49d62b1d6b717af" => :yosemite
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
