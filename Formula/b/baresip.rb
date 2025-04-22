class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "cdd4ee5b37e3a21b12848f1e14b7998cdb23c040e2057909b3e6725ba1799322"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_sequoia: "d2675a50231a7a8617fa1d3681b0771872b7b4fbf1396c9d38cf4dc6733f0903"
    sha256 arm64_sonoma:  "c499fa9f9b58f0747967fc41ed8c453b6a534f7f7edee5f06423c537d913945a"
    sha256 arm64_ventura: "ab41f3f7e90966b0e9bc433a6f8c794f5ca435a9032af70bece13f78533fc6be"
    sha256 sonoma:        "4c1bf351c7ba218bb5387b8d74b53bc71bde1e95c00524cd325f8b8dcfd5009a"
    sha256 ventura:       "8083783cca9fd979d801b12ce42f36035152d2b9e3a183b93f586dc031be93f1"
    sha256 arm64_linux:   "1f9db97c54f54c4e328fe5c4d1e4f39be6bca0eb1c66972d810470403c7d9c9c"
    sha256 x86_64_linux:  "17288171c66e6addae0c0a26aaaae38dfd79942e5c9d132bc48d70f08367a0ae"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
