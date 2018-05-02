class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/current/sdk/c/start-using-sdk.html"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libcouchbase-2.8.7.tar.gz"
  sha256 "a0bea9561e40b4a59e6e80d1da9b08e76c1dd0f97ef4f98552dcf06cae561afc"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "afa810b4378877d54b4a29353ff14fb3aaeb31d96586639c0b52e82481ba18dc" => :high_sierra
    sha256 "2542e974f90c58b5ad3f72e4f2ce912fe5c194d531e1d5f847d214be65425aca" => :sierra
    sha256 "180b63e24f0e58b56730d2cc62b43d862937408c5f24a5b35a2aba58072d2908" => :el_capitan
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
