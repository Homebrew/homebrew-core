class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://developer.couchbase.com/documentation/server/current/sdk/c/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.9.5.tar.gz"
  sha256 "2d8c1df339066619e2491ccca5d50164190abfacb38cab24a3190e73649707bd"
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "e650e06eb80943554f2fded5e8dad027f95ed987ac512390259751e77e36a057" => :mojave
    sha256 "9fb25bbc2af910b793e895695e1c74b557dfe2ac7caf06d02aefb33306f38f2b" => :high_sierra
    sha256 "4a836e3578bb12efab25921e5dceef03f81d611f763986fc1a3619d8bf88f480" => :sierra
    sha256 "101ab4fecd83172c64aae11afe2ac5474f9d3c02bff35825e793f44837aa0893" => :el_capitan
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
