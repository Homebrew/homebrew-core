class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/4.5/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.8.2.tar.gz"
  sha256 "ec788d9db82287b82310aae7ac5543f4a054c6dd49e33fb88ff1ec0ba3d436ef"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "c7e69d74a02e0d0ab5791199712652839ab64ed3ffd0c44ed65b4dafcd62bb36" => :high_sierra
    sha256 "5e587507752ca48c56506ac07115b8a994aa1fced9d9231cc075aad1fc8dfded" => :sierra
    sha256 "0f88bd920da9825405e966071fc3f6ce56f2318227e2437a1be077d9dba29827" => :el_capitan
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
