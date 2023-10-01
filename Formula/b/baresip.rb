class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "622122edf376145870bc7749af0463c5f04a668b3d095c025b718f1910f1b77b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_ventura:  "b1d138965195bbfbd1a99fa170fc79e752cd5516e8da79acc631242bab38015e"
    sha256 arm64_monterey: "65d5fffcdf78d5dc1ce05c6c77e292d2956acf8d3fb4c2b56e72deb248521f0f"
    sha256 arm64_big_sur:  "68f0d30cd925bfd35b8e1125a01cd42901f6cdee4c916e50b53dd1f42759657c"
    sha256 ventura:        "0366b6521dd81370af41e2b448596dcb258638ebbdf86b205547af6eb1e31c73"
    sha256 monterey:       "37e695efbeac83a59e1a27bec079a5c0c8473a34b4eaa8edd0785582da4b5af9"
    sha256 big_sur:        "35a448b5467a408a8b4789b64492a89fadf1876ef93c7c05a0cf23436b6831f5"
    sha256 x86_64_linux:   "d6cc0a7aab9a239df5a885912d96cb62026df26c8d9111b7a7dd8399dd8b35e5"
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
