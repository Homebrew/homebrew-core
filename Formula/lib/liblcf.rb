class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8.1/liblcf-0.8.1.tar.xz"
  sha256 "e827b265702cf7d9f4af24b8c10df2c608ac70754ef7468e34836201ff172273"
  license "MIT"
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b50d8d26ad9ae4223f2b32c6e6339286076967625db097d6f59e51e301839ef"
    sha256 cellar: :any,                 arm64_sonoma:  "b46ebee74b740c0c6fab8ed2c4d54126a190cb2f16d9c6528e9900e3dc51fb0e"
    sha256 cellar: :any,                 arm64_ventura: "c36ac2cb17b1d1057e197d9e2f22d8dae23d1d44142dfab5d595e46edc6cb1fd"
    sha256 cellar: :any,                 sonoma:        "a043c615f9b5d1c946eeec170beebf0fcdb561ff35f7bbc34561102519e3f452"
    sha256 cellar: :any,                 ventura:       "8088af20377163a45aac512fc22a33d774d888dbe7becac630eda6ffa29cb0b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dbcfc8241bf5efa4380109aed635b6107a0f53fb0f698bf469e3f2a50a4c6ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beefb8b7b075411dc9335ea16e330d963cf8d02f3e9d8d4b5f706ca82ecdcd03"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@77"
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
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-llcf", \
      "-o", "test"
    system "./test"
  end
end
