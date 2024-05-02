class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2024-04a",
      revision: "aab122ede8b04a9877e22c9013c0b020186bc9b4"
  version "2024-04a"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9a092170226b0be6aeffd0efb1a5a8c180fe61f2a628f7c35a7568f58c8676f"
    sha256 cellar: :any,                 arm64_ventura:  "715f4f6515ea63c984be300ecb94728c39cb024fc2c4a9aabd4eaa99ead2e1be"
    sha256 cellar: :any,                 arm64_monterey: "b8156f43e9ebcd28952d12f99388ff0c4a89c68d0ef352400769fd29da668ef0"
    sha256 cellar: :any,                 sonoma:         "28708679fab80769d2bf70dd85b3af96adc0526f0ead10a4f0a7a8a26ed50e3b"
    sha256 cellar: :any,                 ventura:        "7c1d4950780996b05cfad031db79689327dce03912821a80c3f398043df1030c"
    sha256 cellar: :any,                 monterey:       "626a80c1cbbf2d8f82085b825f762d6750e4819fc23307b400bcca4e9f25d94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecfb693f82990b48732307880d050f5a5a5353c833edbf15421fd82bf2a39667"
  end

  depends_on "glfw"
  depends_on "llvm@17"
  depends_on "raylib"

  fails_with gcc: "5" # LLVM is built with GCC

  resource "raygui" do
    url "https://github.com/raysan5/raygui/archive/refs/tags/4.0.tar.gz"
    sha256 "299c8fcabda68309a60dc858741b76c32d7d0fc533cdc2539a55988cee236812"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }

    # Delete pre-compiled binaries which brew does not allow.
    system "find", "vendor",
                   "(",
                     "-name", "*.lib",   "-o",
                     "-name", "*.dll",   "-o",
                     "-name", "*.a",     "-o",
                     "-name", "*.dylib", "-o",
                     "-name", "*.so.*",  "-o",
                     "-name", "*.so",
                   ")",
                   "-delete"

    cd buildpath/"vendor/miniaudio/src" do
      system "make"
    end

    cd buildpath/"vendor/stb/src" do
      system "make", "unix"
    end

    cd buildpath/"vendor/cgltf/src" do
      system "make", "unix"
    end

    if OS.mac?
      raylib_installpath = Hardware::CPU.arm? ? "vendor/raylib/macos-arm64" : "vendor/raylib/macos"

      ln_s Formula["glfw"].lib/"libglfw3.a", buildpath/"vendor/glfw/lib/darwin/libglfw3.a"

      ln_s Formula["raylib"].lib/"libraylib.a", buildpath/raylib_installpath/"libraylib.a"
      # This is actually raylib 5.0, but upstream had not incremented this number yet when it released.
      ln_s Formula["raylib"].lib/"libraylib.4.5.0.dylib", buildpath/raylib_installpath/"libraylib.500.dylib"

      resource("raygui").stage do
        cp "src/raygui.h", "src/raygui.c"

        # build static library
        system ENV.cc, "-c", "-o", "raygui.o", "src/raygui.c",
          "-fpic", "-DRAYGUI_IMPLEMENTATION", "-I#{Formula["raylib"].include}"
        system "ar", "-rcs", "libraygui.a", "raygui.o"
        cp "libraygui.a", buildpath/raylib_installpath

        # build shared library
        system ENV.cc, "-o", "libraygui.dylib", "src/raygui.c",
          "-shared", "-fpic", "-DRAYGUI_IMPLEMENTATION", "-framework", "OpenGL",
          "-lm", "-lpthread", "-ldl",
          "-I#{Formula["raylib"].include}", "-L#{Formula["raylib"].lib}", "-lraylib"
        cp "libraygui.dylib", buildpath/raylib_installpath
      end
    end

    # Keep version number consistent and reproducible for tagged releases.
    args = []
    args << "ODIN_VERSION=dev-#{version}" unless build.head?
    system "make", "release", *args
    libexec.install "odin", "core", "shared", "base", "vendor"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a odin "#{libexec}/odin" "$@"
    EOS
    pkgshare.install "examples"
  end

  test do
    (testpath/"hellope.odin").write <<~EOS
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    EOS
    system "#{bin}/odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output("./hellope")

    (testpath/"miniaudio.odin").write <<~EOS
      package main

      import "core:fmt"
      import "vendor:miniaudio"

      main :: proc() {
        ver := miniaudio.version_string()
        assert(len(ver) > 0)
        fmt.println(ver)
      }
    EOS
    system "#{bin}/odin", "run", "miniaudio.odin", "-file"

    if OS.mac?
      (testpath/"raylib.odin").write <<~EOS
        package main

        import rl "vendor:raylib"

        main :: proc() {
          // raygui.
          assert(!rl.GuiIsLocked())

          // raylib.
          num := rl.GetRandomValue(42, 1337)
          assert(42 <= num && num <= 1337)
        }
      EOS
      system "#{bin}/odin", "run", "raylib.odin", "-file"
      system "#{bin}/odin", "run", "raylib.odin", "-file",
        "-define:RAYLIB_SHARED=true", "-define:RAYGUI_SHARED=true"

      (testpath/"glfw.odin").write <<~EOS
        package main

        import "core:fmt"
        import "vendor:glfw"

        main :: proc() {
          fmt.println(glfw.GetVersion())
        }
      EOS
      system "#{bin}/odin", "run", "glfw.odin", "-file"
    end
  end
end
