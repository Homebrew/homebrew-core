class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "be712ffe225fd06dfaa4c756b58daaa7616581b629a23114b43c0423171f92d8"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_ventura:  "c1dc8afb0e448aa81623b77196162c5516cfa9a0c42721522ee5c7f5f860a906"
    sha256 arm64_monterey: "f9bb55ffb5df8212ea5173693933c8182d61aee045b6981851e8d8ece6dfb493"
    sha256 arm64_big_sur:  "620b54af5797414e37af5f6d5285c9ed3166fbc26b0eed6c2538f335081e8685"
    sha256 ventura:        "4d48d43d04756bde82963d2762c4c43c3fb9a2c7e2e3ac30f922e0cd0575f347"
    sha256 monterey:       "74ffe8503f53098459ca2d6607013e6351cca00dcc2db11f38c28ae1c2844110"
    sha256 big_sur:        "c649f74acce77ca1f18f74b408258bed96ba0eb718f2c1a568d639126b229910"
    sha256 x86_64_linux:   "3ae5a383af074fc01a6cd0f1bdc0205df1dba226c078771873f199cfa0b9ca88"
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
