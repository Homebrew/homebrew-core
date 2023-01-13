class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "fe0aeb3ae1d9c2d3bcc6d1a53adb8dbd34740de287a40a2d59d6c0cec58943c7"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_ventura:  "7e62d8094d091a3a66be7a0e19df3c54c80a27dfb029b2c25c12cd8a14522eed"
    sha256 arm64_monterey: "cd7ac2867683c110fe7248e5b7bc4231cd8f0bcb5842554cd61e22c21e2a13f9"
    sha256 arm64_big_sur:  "82d29c691a6a032af6201dbe3aebaa9376a0be2b9f2322279dd8ec4b22342237"
    sha256 ventura:        "0f03d80938e43f78efc62611a2cf336e68ff7ddb8fada3dd1c488e52c14606be"
    sha256 monterey:       "5c752d177687a9aafa852749a635bb0d620b4a64d7820007f0dd2bd12eacb39d"
    sha256 big_sur:        "7064d966690cd20890df14aa98985ab460b03418c473bf4242e245f5a79f617c"
    sha256 x86_64_linux:   "978e3ed2d26adcb80c096cddf4242f60eb53afcbaeba36c2a5cbb8b7facc9c95"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"
  depends_on "librem"

  def install
    libre = Formula["libre"]
    librem = Formula["librem"]
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}/re
      -DREM_INCLUDE_DIR=#{librem.opt_include}/rem
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
