class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "175e5179368cdb4341f1611f56adf3ac03dd1faaf2c3c66fc0e00694265d327b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "656d5dee56a4ba3c497c2eb08decffc0afe1b990595a4033d2d503180ce1e6ea"
    sha256 arm64_sequoia: "11e88bba71ea5c93f4c58ce3cc85d5307fd4a6bfb4fbc82639196573dda7e120"
    sha256 arm64_sonoma:  "33fd3b176eb4d2a445edb1c95990b60bc93ece93dc0ca20519ed1874ea602d3a"
    sha256 sonoma:        "e4c8c8f15849b27216cda0388470f691e4f0086d7b83988d987966a2db3b7ab1"
    sha256 arm64_linux:   "0fc1a0797d9b20d8ead8c7b6c57c987629e99e2fa20730be51fb4fef4f2d66e3"
    sha256 x86_64_linux:  "b5d033150c4af801878c70d526f8f6be5c5b3f8d445e258d2493b12dd1b24d9b"
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
