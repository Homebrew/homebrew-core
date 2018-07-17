class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/current/sdk/c/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.9.3.tar.gz"
  sha256 "cd3bba99d5e4935240e502535c3275e0756b480c6bc6746a46fb745d5e7066e4"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "131a11716f307b1018f390a763365a1be455fb6d755275e527804586de078a79" => :high_sierra
    sha256 "3b42d1db3a380490cb34d68bbfc3069c67376bb5ebaa2f383cbc85f3bf7688d9" => :sierra
    sha256 "9de059703cea2aea7576ca705266c29e3bb311cca6f9774dbe524b3bac873278" => :el_capitan
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
