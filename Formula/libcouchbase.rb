class Libcouchbase < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.4.tar.gz"
  sha256 "3b1f6c1b4e728d119fc4f9976f296e5930b95a2d94e1b21f407bf35d93a9f40f"
  revision 2
  head "https://github.com/couchbase/libcouchbase.git"

  bottle do
    sha256 "89a3065f7e41407d79703eb0a313f64e274d42ff4d277f90cce8f446759cd1c4" => :mojave
    sha256 "ea6d826f48e152b7b351d5e480c4f83c1c5fe58bdb7b59bfbdfde0542d9da181" => :high_sierra
    sha256 "517d728c9f0a2ed832f26f9fc47f04e7816c79cad861c7852813007b9a213fca" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

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
