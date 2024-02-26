class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8/liblcf-0.8.tar.xz"
  sha256 "6b0d8c7fefe3d66865336406f69ddf03fe59e52b5601687265a4d1e47a25c386"
  license "MIT"
  revision 2
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6b2a50537cda6de3f2de66da5eab8887b60e2fe89b773737b5f18b936305244"
    sha256 cellar: :any,                 arm64_ventura:  "ef2914abc50f38f5cd948c70513925e16b46cca7e523e26d480cd77465c21a32"
    sha256 cellar: :any,                 arm64_monterey: "d69068fe28272da2f397082bfa60f98ea942df2200dab9fd7f8df2e5472700d6"
    sha256 cellar: :any,                 sonoma:         "c5343e23925ac2afbaec41331cad08c65bdebd775cf237f595b8b40cc258034c"
    sha256 cellar: :any,                 ventura:        "6d76007219de8377928af43b548b0636793939f1f5211e20bb3d6fcf8b4f5963"
    sha256 cellar: :any,                 monterey:       "a8c0422b3d5d91e6af9de8165169a600b6313676132efe2d8cfc6dca2e533bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18460590e8ae8ded3470cda06540fe6431c93da712e7e32f7ac5155a8527f3ab"
  end

  depends_on "cmake" => :build
  depends_on "expat" # Building against `liblcf` fails with `uses_from_macos`
  depends_on "icu4c"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLIBLCF_UPDATE_MIMEDB=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "lcf/lsd/reader.h"
      #include <cassert>

      int main() {
        std::time_t const current = std::time(NULL);
        assert(current == lcf::LSD_Reader::ToUnixTimestamp(lcf::LSD_Reader::ToTDateTime(current)));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{lib}", "-llcf", \
      "-o", "test"
    system "./test"
  end
end
