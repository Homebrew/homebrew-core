class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "fa281d041e6c5d02f9f71b88524ca8fe05b54d37bbdf985f44fb6a034e02a604"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "03f6a32353e1147a8a70e483ddf28a4f0423b6932f2e8028a0c8a1d2ee03a541"
    sha256 arm64_sequoia: "f7067437db59bf7c870a7383dcc2b7a880349532987673213575f869eb77950d"
    sha256 arm64_sonoma:  "34b13de302e1ec33880078166a799a735e558dc3ba2b4c8f9c21a38c7e541f04"
    sha256 sonoma:        "06c0431350efe08d713689776e9e559a10b8bc63ef1b0f78fae798b46011c15a"
    sha256 arm64_linux:   "555db0a500acf127f89b074b4afb444fe1ad18387f2b430d514850130a6d397f"
    sha256 x86_64_linux:  "3229e501f5738da0144381e939415389d02fb584b3fe8e22aeea617309415cc2"
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
