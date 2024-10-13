class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "95338c4e4dd6931c94d425d69089b66d32c173e48cb992344e856ead7ba9393b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "49a8420cd3d1396970d6ac46087d834f32ca854bffc962f4854344300a0f8636"
    sha256 arm64_sonoma:  "432052f6f43a9b98496614ec023a91c05c87d5efda3a65a1947f3c437c37f179"
    sha256 arm64_ventura: "744a1ef3f143f0e61638b1a6d7f5305e0c579322b0bf97c4ee45da08af13d1af"
    sha256 sonoma:        "287fc83ff9ec9eb95a625c30bb966c77e7994de44f27dcbaf9b716acaa7414e9"
    sha256 ventura:       "fba7e99b3b3956476c8cd60caee9abef3b2d4eb3cec0e8dbc539a656902ed92b"
    sha256 x86_64_linux:  "288f35f9a26024105b41af71df13cc0aaa61253316dc1423a0a27cbdbf5cd427"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

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
