class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8.1/liblcf-0.8.1.tar.xz"
  sha256 "e827b265702cf7d9f4af24b8c10df2c608ac70754ef7468e34836201ff172273"
  license "MIT"
  revision 2
  compatibility_version 1
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cfa7265ad02447a6e381dd7565e4f50235e61454771f5328af862515693b9384"
    sha256 cellar: :any, arm64_tahoe:       "8d03fd474505ff1154e6d85b1c66134dc3578ef81010475253764f3da7e6305b"
    sha256 cellar: :any, arm64_sequoia:     "b3044c38bc74dcd8126e52d44d8ac5f7210eb3cd3cc67fe53bf07d6cbd3408c7"
    sha256 cellar: :any, arm64_linux:       "ae65923c3407a2db89adefb82d534ca00e0a49ff591a551d73aca54177997c6a"
    sha256 cellar: :any, x86_64_linux:      "79f5d4b294c566931f16e1d0ae4491ceddcdbc49ad71dff7f41fbb51cd25fe81"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@79"
  depends_on "inih"

  uses_from_macos "expat"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLIBLCF_UPDATE_MIMEDB=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "lcf/lsd/reader.h"
      #include <cassert>

      int main() {
        std::time_t const current = std::time(NULL);
        assert(current == lcf::LSD_Reader::ToUnixTimestamp(lcf::LSD_Reader::ToTDateTime(current)));
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-llcf",
      "-o", "test"
    system "./test"
  end
end
