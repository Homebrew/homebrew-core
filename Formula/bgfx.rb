class Bgfx < Formula
  desc "Cross-platform, graphics API agnostic, rendering library"
  homepage "https://github.com/bkaradzic/bgfx"
  url "https://github.com/bkaradzic/bgfx.cmake.git",
      tag:      "v1.115.7947-b455d69",
      revision: "b455d69ebc21022f818b8cec712ade6d339922cc"
  license any_of: ["CC0-1.0", "BSD-2-Clause"]
  head "https://github.com/bkaradzic/bgfx.cmake.git", branch: "master"

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
    depends_on "mesa"
  end

  def install
    rev = Utils.safe_popen_read("git", "--git-dir", "bgfx/.git", "rev-list", "HEAD", "--count").strip
    sha1 = Utils.safe_popen_read("git", "--git-dir", "bgfx/.git", "rev-parse", "HEAD").strip

    inreplace "bgfx/src/version.h", /BGFX_REV_NUMBER.*$/, "BGFX_REV_NUMBER #{rev}"
    inreplace "bgfx/src/version.h", /BGFX_REV_SHA1.*$/, "BGFX_REV_SHA1 \"#{sha1}\""

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
