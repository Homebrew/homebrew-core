class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.7.6.tar.gz"
  sha256 "9b0c2a4de38963ec3314d19e50d63cc34a5990a4f6e0a81973c019d5ad83c411"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "329d5605fd071b4729468dc074610c7a6fee55c85f1c65e889c717ed1d025408" => :sierra
    sha256 "fe5ee10dde4050b302281b725e565e93e564c91ef693940fd906faf271a1b991" => :el_capitan
    sha256 "edb8d1de8a5772740dfdca2d0293576d27b90013715f2ff7df01fcef8b7b1539" => :yosemite
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
