class Josepp < Formula
  desc "JSON Object Signing and Encryption library for C++"
  homepage "https://github.com/troian/josepp"
  url "https://github.com/troian/josepp/archive/v1.1.0.tar.gz"
  sha256 "2db32c2220784698b4242c64d5835d2f2efb4c9cf3163051d5ef611c1181f5c8"
  head "https://github.com/troian/josepp.git"

  bottle do
    cellar :any
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "pkg-config"
  depends_on "openssl"
  depends_on "jsoncpp"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  def install
    ENV.cxx11

    (buildpath/"gtest").install resource("gtest")

    mkdir "build" do
      args = std_cmake_args + %W[
        -DWITH_TESTS=ON
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_MACOSX_RPATH=1
        -DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}
      ]
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "./josepp_test"
  end
end
