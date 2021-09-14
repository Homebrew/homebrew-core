class Bgfx < Formula
  desc "Cross-platform, graphics API agnostic, rendering library"
  homepage "https://github.com/bkaradzic/bgfx"
  url "https://github.com/bkaradzic/bgfx/archive/403b69db7876bc7269f546273bba57c40d2b137e.tar.gz"
  version "1.115.7816"
  sha256 "f6808e6011e93470d1c60be6d371e905e5c703067dc0ee21b7c8943c60f8e042"
  license "BSD-2-Clause"
  head "https://github.com/bkaradzic/bgfx.git", branch: "master"

  depends_on "cmake" => :build

  on_linux do
    depends_on "mesa"
  end

  resource "bimg" do
    url "https://github.com/bkaradzic/bimg/archive/6693de0e50ff7e76a22d6f37251fa2dec12168cd.tar.gz"
    sha256 "d5413c1518367549f52bd2d99ced06d91bc8d4a88469007697ea2b8af8141e97"
  end

  resource "bx" do
    url "https://github.com/bkaradzic/bx/archive/e50536ac03eb404f50123d23f2c9ab2b3e4663e7.tar.gz"
    sha256 "f182558d2f87197e86a5c428af4e2ccdbf6e264fbe2b66ff10d10a6013873422"
  end

  resource "bgfx.cmake" do
    url "https://github.com/bkaradzic/bgfx.cmake/archive/2c37f3ec62ae1f93525143358ad550b50edfbc55.tar.gz"
    sha256 "ffa83286f091a7bec5edf2ddd91ba1515a08864107622f8778bdd7a78d314619"
  end

  def install
    (buildpath/"bgfx").install Dir["*"]
    (buildpath/"bimg").install resource("bimg")
    (buildpath/"bx").install resource("bx")
    buildpath.install resource("bgfx.cmake")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bx/bx.h>
      #include <bgfx/bgfx.h>
      #include <bgfx/platform.h>
      int main(void) {
        bgfx::renderFrame();
        bgfx::Init init;
        init.type = bgfx::RendererType::Noop;
        init.resolution.width = 100;
        init.resolution.height = 100;
        init.resolution.reset = BGFX_RESET_VSYNC;
        bgfx::init(init);
        bgfx::shutdown();
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lbgfx
      -lbx
      -lbimg
      -lastc-codec
      -framework AppKit
      -framework Metal
      -framework QuartzCore
    ]
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
