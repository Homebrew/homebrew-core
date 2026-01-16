class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8.1/liblcf-0.8.1.tar.xz"
  sha256 "e827b265702cf7d9f4af24b8c10df2c608ac70754ef7468e34836201ff172273"
  license "MIT"
  revision 1
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c70e1c25f43bd1afb5cded83eeea2c881255af73ea1fcbc9b997d598418b455f"
    sha256 cellar: :any,                 arm64_sequoia: "6a2722660c5d96461a555e686202a7a9b10199434a81418e87fae39b94832da3"
    sha256 cellar: :any,                 arm64_sonoma:  "083c35e52b98fab1615961b3328d1a9a023bb074fd0337b0266f9f6fbb412ad9"
    sha256 cellar: :any,                 sonoma:        "b5f3a2a51b789a81455b7619889327260a3b7c3a624a6d39ff72df566e6a1089"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12c761ee5225d3f19c5b16dc98851daa031eb0f554d297866879ab9415b276a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e17a85a805ff92cbd72063eb5a5d724f894938fcdf8a0ccbf996016c4f926715"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@78"
  depends_on "inih"

  uses_from_macos "expat"

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
