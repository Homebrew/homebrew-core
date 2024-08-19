class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2024-08",
      revision: "1a16585b10044255097e0abaa73aa4f0a422cbd1"
  version "2024-08"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9c4bdd572668c9f55a76f9956d6643695862347e29bebca9e73a96ca8c7f0864"
    sha256 cellar: :any,                 arm64_ventura:  "97e4e94646429fdb73c2cbcde033b3f7a9ff36812b49d1ca16d5bb1e9519de19"
    sha256 cellar: :any,                 arm64_monterey: "295781e8c2a00667d90d398f9557cb34b8cdbf6c76c503885ee44a29c4ca949d"
    sha256 cellar: :any,                 sonoma:         "71a0e2e49fd9f0d25c8cbf6d34c7d3aa360c75cc86bf56c80b2687303a2bf83e"
    sha256 cellar: :any,                 ventura:        "5799cab2b340caddc720ca99c99d3f5798a736dc1cd757e84bf5ca347b17af1e"
    sha256 cellar: :any,                 monterey:       "3cbeff8fc1a0b581dec9f26bf5152d34baedfe58d3c8a90968a7e04e3c7e62e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67e3d2c82e9f76636f43567a989411dc8a0b7301ee46c72dbe1fa51d9e75657"
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

    # By default the build runs an example program, we don't want to run it during install.
    # This would fail when gcc is used because Odin can be build with gcc,
    # but programs linked by Odin need clang specifically.
    inreplace "build_odin.sh", /^\s*run_demo\s*$/, ""

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
    system bin/"odin", "build", "hellope.odin", "-file"
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
    system bin/"odin", "run", "miniaudio.odin", "-file"

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
      system bin/"odin", "run", "raylib.odin", "-file"
      system bin/"odin", "run", "raylib.odin", "-file",
        "-define:RAYLIB_SHARED=true", "-define:RAYGUI_SHARED=true"

      (testpath/"glfw.odin").write <<~EOS
        package main

        import "core:fmt"
        import "vendor:glfw"

        main :: proc() {
          fmt.println(glfw.GetVersion())
        }
      EOS
      system bin/"odin", "run", "glfw.odin", "-file"
    end
  end
end
