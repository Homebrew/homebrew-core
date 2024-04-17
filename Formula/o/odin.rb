class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2024-04a",
      revision: "aab122ede8b04a9877e22c9013c0b020186bc9b4"
  version "2024-04a"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c72adb334df03cfc13dbc44e856f275e3f2c79b52fded838d7183ebfc0bc641"
    sha256 cellar: :any,                 arm64_ventura:  "b030289987283ccadd6a22971533ffe6df589a5ffd9b367c11b74ea54ef5f2f4"
    sha256 cellar: :any,                 arm64_monterey: "90381dcddb9f980548919b52185e7c91633dc8e0a5ec14334f5876cc236417c3"
    sha256 cellar: :any,                 sonoma:         "905c623014c85d2a1fb64c076cd50a00bff170129e8bb471addf8618e593270f"
    sha256 cellar: :any,                 ventura:        "d2bb15733c16e3c717cafa1421a70e15c563f13483141a5da76d108c67f5c3be"
    sha256 cellar: :any,                 monterey:       "09eb8b912ea05660dfcf7a378e0259572f6a8ea869e525b3d07a37e804546131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4e039b6b6832473aaba910d497f7bb6c7429df6f857fa7d48ae5baf876c69b6"
  end

  depends_on "glfw"
  depends_on "llvm"
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
