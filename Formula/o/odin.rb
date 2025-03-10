class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2025-03",
      revision: "951bef4ade595e5fa7e8f0d0681e4e34ab1ca9d3"
  version "2025-03"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "89b40c3b71830dcc8cb4ae44fba4b0f7ab2a7f760a262ec92768f946834b21f0"
    sha256                               arm64_sonoma:  "32c2d47d4a8f0c3cdadee039feccca4a01f1bd098e561fcff4cbf3704060469c"
    sha256                               arm64_ventura: "c37ca002090d2b6fc177870fc8c713aba96fbc1b8ed5aea6004d3ff92d26a647"
    sha256 cellar: :any,                 sonoma:        "ed9e94ec79594275e983649728cd2f7369bd70b39f22bc4457d166d7a3dd7ec5"
    sha256 cellar: :any,                 ventura:       "66f1867b718fa84fe25e5a216b00fbe3ab8f2096736e2a921be0e6ccddd16b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c50287712e2c32204fa12bd11abaa58e0c12d614ec70e86742bab9d40a4f04"
  end

  depends_on "glfw"
  depends_on "llvm@19"
  depends_on "raylib"

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
    else
      "vendor/raylib/macos"
    end

    raygui_installpath = if OS.linux?
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
    # In order to match the version 500 used in odin
    ln_s Formula["raylib"].lib/shared_library("libraylib", "5.5.0"),
      buildpath/raylib_installpath/shared_library("libraylib", "550")

    resource("raygui").stage do
      cp "src/raygui.h", "src/raygui.c"

      # build static library
      system ENV.cc, "-c", "-o", "raygui.o", "src/raygui.c",
        "-fpic", "-DRAYGUI_IMPLEMENTATION", "-I#{Formula["raylib"].include}"
      system "ar", "-rcs", "libraygui.a", "raygui.o"
      cp "libraygui.a", buildpath/raygui_installpath

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
      cp shared_library("libraygui"), buildpath/raygui_installpath
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
    (bin/"odin").write <<~BASH
      #!/bin/bash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a odin "#{libexec}/odin" "$@"
    BASH
    pkgshare.install "examples"
  end

  test do
    (testpath/"hellope.odin").write <<~ODIN
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    ODIN
    system bin/"odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output("./hellope")

    (testpath/"miniaudio.odin").write <<~ODIN
      package main

      import "core:fmt"
      import "vendor:miniaudio"

      main :: proc() {
        ver := miniaudio.version_string()
        assert(len(ver) > 0)
        fmt.println(ver)
      }
    ODIN
    system bin/"odin", "run", "miniaudio.odin", "-file"

    (testpath/"raylib.odin").write <<~ODIN
      package main

      import rl "vendor:raylib"

      main :: proc() {
        // raygui.
        assert(!rl.GuiIsLocked())

        // raylib.
        num := rl.GetRandomValue(42, 1337)
        assert(42 <= num && num <= 1337)
      }
    ODIN
    system bin/"odin", "run", "raylib.odin", "-file"

    if OS.mac?
      system bin/"odin", "run", "raylib.odin", "-file",
        "-define:RAYLIB_SHARED=true", "-define:RAYGUI_SHARED=true"
    end

    (testpath/"glfw.odin").write <<~ODIN
      package main

      import "core:fmt"
      import "vendor:glfw"

      main :: proc() {
        fmt.println(glfw.GetVersion())
      }
    ODIN
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["glfw"].lib if OS.linux?
    system bin/"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=true",
      "-extra-linker-flags:\"-L#{Formula["glfw"].lib}\""
    system bin/"odin", "run", "glfw.odin", "-file", "-define:GLFW_SHARED=false"
  end
end
