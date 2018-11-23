class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.2.tar.gz"
  sha256 "65e8be11993ba01f5a7b8299e5e78765290b465d42a538ac12ea0d3ca3a7ecd3"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "e3cd2cafe25d10169291f095c65407cf197c665a11b446484b2468086ebb19ca" => :mojave
    sha256 "94e329a7142c964c242016fb73983bfa2f21cceff462073c531856851653292a" => :high_sierra
    sha256 "99b7efb8c1d045266975b6e825bd74a095bc28adf68d6184e355ff162983f3af" => :sierra
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
