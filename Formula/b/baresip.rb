class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.22.0.tar.gz"
  sha256 "a9e7884fa796f47640fe0854485229a0357eb9a6913fa7909bc92bab6148fe04"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_sequoia: "5ceaa071913d0d3fc53253c33c8e108b18cb61d2a2e7d7bca8591638234810f9"
    sha256 arm64_sonoma:  "0ac329d132fc17565506d32546232a381abaa4738b636fbd35430c402d8a065d"
    sha256 arm64_ventura: "69046a45077cbdeb61b6a34c4b54721b749a1fe2cc9731411ea0cfa989fc96d7"
    sha256 sonoma:        "3a92e4a38a530f636283b8109caa66a2d812f00349441f1a922ee4f67b722d49"
    sha256 ventura:       "5e713fb7d5a28e199ce2d92f8d41665fe8d7fb067dcc1cf326e468c444f43657"
    sha256 arm64_linux:   "8f87bc63ae6a6f72197982bed3cb5285f2018dba774c669a9eb9a8812be939a3"
    sha256 x86_64_linux:  "e552113a1671d38c0cba89cec6cd68a9e1d802ba4e95b0d3d83d5f926ad7020a"
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
