class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "de69823a54ecd057a9ffc0ca6f9b3cf9562848da1f15d5df8a97a4ae6f8daf37"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_ventura:  "05357994224d3cd372fef4bc8adda51ca83c4d74616e78f41e8775da5af789fa"
    sha256 arm64_monterey: "f62abda5b8dc1ffdad22e14e8d8add15669e485b92d256ef37973f9f794ba660"
    sha256 arm64_big_sur:  "dac4497682f764218d6edc597de9c386c919d4b07039123b3ff0cf665d744790"
    sha256 ventura:        "0cd1bfef567d4da937c9f26ed5857bd7751b49fd1f146dc7ea71948bedcdffea"
    sha256 monterey:       "91e74a77b255ad3845894b6d3d8612ebc77352f6f63ccc333a172ca571cbfcd2"
    sha256 big_sur:        "e51b67f393177d2b6f8a8a5a7fb2d302a80bf8e0514dafde9f6aac2bc85c4e3d"
    sha256 x86_64_linux:   "f7c01c71bafc60d3cbd02cfe15792b513bf8997f8db8f298b8432be00348228e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}/re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
