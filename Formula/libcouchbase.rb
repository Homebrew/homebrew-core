class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.2.tar.gz"
  sha256 "65e8be11993ba01f5a7b8299e5e78765290b465d42a538ac12ea0d3ca3a7ecd3"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "3318ef1004b7a30355ea9f7e5f85fddc67d0f126899abb9376e2bcb69ad273c8" => :mojave
    sha256 "7b8911d3027662f3903f2d741057a9bbf1c99374fc672e07207897dbe8a0c52e" => :high_sierra
    sha256 "11c68b0215d3a382affc23dd93839a5b22b949eb29493397fddc7c8f478b5639" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DLCB_NO_TESTS=1",
                            "-DLCB_BUILD_LIBEVENT=ON",
                            "-DLCB_BUILD_LIBEV=ON",
                            "-DLCB_BUILD_LIBUV=ON"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cbc", "version"
  end
end
