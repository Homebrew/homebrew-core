class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2026-04",
      revision: "a896fb2b4c8367f5e10caf76e09d90db07728929"
  version "2026-04"
  license "Zlib"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "98ecf3500d2445351c8355496ba4733210d55aa5d7c66849d19a984091c37f38"
    sha256                               arm64_sequoia: "a3ca9a4cd47feee06c486934b7e4911ce34501418f2e507e4ae4faa107e44b98"
    sha256                               arm64_sonoma:  "7cc2c1ed1280dc7a3c8e6c4c92dffa0bd20c06e20374a0dcc5a47cde16e860f3"
    sha256 cellar: :any,                 sonoma:        "f512936e924400799d0099df4b902104a34a3aacbe15c7422d4a6b0be6fea863"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdb0040f9e4f797b562a255ce4d5f0d00cddaeb88d171234d48297faa80f3077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6ec7fb0a3fde315f865558ca7d8f86a02b3d937430add9ebb3cde31f5d08439"
  end

  depends_on "glfw" => :no_linkage
  depends_on "lld"
  depends_on "llvm"
  depends_on "raylib"

  fails_with :gcc do
    cause "requires Clang"
  end

  resource "raygui" do
    url "https://github.com/raysan5/raygui/archive/refs/tags/4.0.tar.gz"
    sha256 "299c8fcabda68309a60dc858741b76c32d7d0fc533cdc2539a55988cee236812"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    ENV["LLVM_CONFIG"] = (llvm.opt_bin/"llvm-config").to_s
    ENV.append "LDFLAGS", "-Wl,-rpath,#{llvm.opt_lib}" if OS.linux?

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
    args << "ODIN_VERSION=dev-#{version}" if build.stable?
    system "make", "release", *args
    libexec.install "odin", "core", "shared", "base", "vendor"
    (bin/"odin").write <<~BASH
      #!/bin/bash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a "${0}" "#{libexec}/odin" "${@}"
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
