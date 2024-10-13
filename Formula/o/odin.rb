class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2024-10",
      revision: "af9ae4897ad9e526d74489ddd12cfae179639ff3"
  version "2024-10"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aca4aec0e727515e10a3c5c552eababb6f0a74805340307c06c8615091130d70"
    sha256 cellar: :any,                 arm64_sonoma:  "513d0754a3c9953e1cd7f237889a27e0b56f0739ff5ae685f32c385399d836d6"
    sha256 cellar: :any,                 arm64_ventura: "9875168b45d9a80a76c8f072ef1a959732f796cf8a6c1754a87e070af47452c0"
    sha256 cellar: :any,                 sonoma:        "ce6be3726f1d2f0016ab6b02b069762b5dadea013a0a07d5dcd955bc2993122e"
    sha256 cellar: :any,                 ventura:       "b94bf5def1e815e33345d3acc769a9d17897b0a6c16fdfba83c2c78b7e525796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0ed5c0aed4747f0f2001ebd47726da716259cd22ee8ff102be6330053528f83"
  end

  depends_on "glfw"
  depends_on "llvm@18"
  depends_on "raylib"

  fails_with gcc: "5" # LLVM is built with GCC

  resource "raygui" do
    url "https://github.com/raysan5/raygui/archive/refs/tags/4.0.tar.gz"
    sha256 "299c8fcabda68309a60dc858741b76c32d7d0fc533cdc2539a55988cee236812"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    ENV["LLVM_CONFIG"] = (llvm.opt_bin/"llvm-config").to_s

    # Delete pre-compiled binaries which brew does not allow.
    buildpath.glob("vendor/**/*.{lib,dll,a,dylib,so,so.*}").map(&:unlink)

    cd buildpath/"vendor/miniaudio/src" do
      system "make"
    end

    cd buildpath/"vendor/stb/src" do
      system "make", "unix"
    end

    cd buildpath/"vendor/cgltf/src" do
      system "make", "unix"
    end

    raylib_installpath = if OS.linux?
      "vendor/raylib/linux"
    elsif Hardware::CPU.intel?
      "vendor/raylib/macos"
    else
      "vendor/raylib/macos-arm64"
    end

    glfw_installpath = if OS.linux?
      "vendor/glfw/lib"
    else
      "vendor/glfw/lib/darwin"
    end

    ln_s Formula["glfw"].lib/"libglfw3.a", buildpath/glfw_installpath/"libglfw3.a"

    ln_s Formula["raylib"].lib/"libraylib.a", buildpath/raylib_installpath/"libraylib.a"
    # This is actually raylib 5.0, but upstream had not incremented this number yet when it released.
    ln_s Formula["raylib"].lib/shared_library("libraylib", "4.5.0"),
      buildpath/raylib_installpath/shared_library("libraylib", "500")

    resource("raygui").stage do
      cp "src/raygui.h", "src/raygui.c"

      # build static library
      system ENV.cc, "-c", "-o", "raygui.o", "src/raygui.c",
        "-fpic", "-DRAYGUI_IMPLEMENTATION", "-I#{Formula["raylib"].include}"
      system "ar", "-rcs", "libraygui.a", "raygui.o"
      cp "libraygui.a", buildpath/raylib_installpath

      # build shared library
      args = [
        "-o", shared_library("libraygui"),
        "src/raygui.c",
        "-shared",
        "-fpic",
        "-DRAYGUI_IMPLEMENTATION",
        "-lm", "-lpthread", "-ldl",
        "-I#{Formula["raylib"].include}",
        "-L#{Formula["raylib"].lib}",
        "-lraylib"
      ]

      args += ["-framework", "OpenGL"] if OS.mac?
      system ENV.cc, *args
      cp shared_library("libraygui"), buildpath/raylib_installpath
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

    if OS.mac?
      system bin/"odin", "run", "raylib.odin", "-file",
        "-define:RAYLIB_SHARED=true", "-define:RAYGUI_SHARED=true"
    end

    (testpath/"glfw.odin").write <<~EOS
      package main

      import "core:fmt"
      import "vendor:glfw"

      main :: proc() {
        fmt.println(glfw.GetVersion())
      }
    EOS
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["glfw"].lib if OS.linux?
    system bin/"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=true",
      "-extra-linker-flags:\"-L#{Formula["glfw"].lib}\""
    system bin/"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=false"
  end
end
