class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2024-03",
      revision: "4c35633e0147b481dd7b2352d6bdb603f78c6dc7"
  version "2024-03"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "aee6d94e1646fee27c7cd012680e501fe84194b71c14b7b2124440a70768f14e"
    sha256 cellar: :any,                 arm64_ventura:  "e271f128611729bb2e5cdd252242a35b7494e8802a5766a9de21c1d5a3a4931f"
    sha256 cellar: :any,                 arm64_monterey: "9173f7f623627195e518c8d64e29cd528dd10203a020e3c1528c02924bf3d2de"
    sha256 cellar: :any,                 sonoma:         "701b0bc8dd8227065a969a387326a82763fe958da1a89e0f8042ecefc9d3dcbf"
    sha256 cellar: :any,                 ventura:        "f765477fcf586524b48a6e68f48f0f636d15b1c8b5141eb88e318c2420ec55a6"
    sha256 cellar: :any,                 monterey:       "52e95a6da8a53eaa67598ed938cdc416a90ae8524d1630b56e1bb46109954444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad7318d24fc90ab95ec1d09c78f9f2cde1078ee2c87e673d00cd7f05cc1f9cb"
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
