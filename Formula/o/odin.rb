class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2026-11",
      revision: "e28f5d1ff420ce2cfd7f1f5a9a91f8b37956445e"
  version "2026-11"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "2d8f8294e825d12cfa666ac5fc169d4f79c79ca9447292a47a1260d1ee6a8bce"
    sha256               arm64_tahoe:       "0ba298f388b4bc9656733cc03d98ab7eb1809a416da17cda50349015e3ab22d1"
    sha256               arm64_sequoia:     "fddcb7c4a04e075260fadeda5c440fc3b7c0c4838baae2c4325641e44db07289"
    sha256 cellar: :any, arm64_linux:       "021f65f487bb31ac4b7af406079bdcb69ed9afc55ac0eda1f83319ee72300f2a"
    sha256 cellar: :any, x86_64_linux:      "0cc1f3af76a4b5896c39f0dcd3c75e049983f167641127ff108242ed54c4b1df"
  end

  depends_on "glfw" => :no_linkage
  depends_on "lld@22"
  depends_on "llvm@22" # TODO: LLVM 23 - https://github.com/odin-lang/Odin/pull/7491
  depends_on "raylib"

  on_linux do
    # Upstream stopped shipping prebuilt Linux raygui libs and links `system:raygui` instead,
    # so link the libraygui compiled from the header-only `raygui` resource below, as on macOS.
    patch :DATA
  end

  fails_with :gcc do
    cause "requires Clang"
  end

  resource "raygui" do
    url "https://github.com/raysan5/raygui/archive/refs/tags/5.0.tar.gz"
    sha256 "0f194c4a5e837c0930aca0b6315db45d00f76fa0052d841eea94598d390c39d6"
  end

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    ENV["LLVM_CONFIG"] = (llvm.opt_bin/"llvm-config").to_s
    ENV.append "LDFLAGS", "-Wl,-rpath,#{llvm.opt_lib}" if OS.linux?

    # Delete pre-compiled binaries which brew does not allow.
    buildpath.glob("vendor/**/*.{lib,dll,a,dylib,so,so.*}").map(&:unlink)

    %w[cgltf miniaudio stb].each do |vendored_dep|
      cd buildpath/"vendor"/vendored_dep/"src" do
        system "./build_#{vendored_dep}.sh"
      end
    end

    glfw_installpath = if OS.linux?
      "vendor/glfw/lib"
    else
      "vendor/glfw/lib/darwin"
    end
    ln_s Formula["glfw"].lib/"libglfw3.a", buildpath/glfw_installpath/"libglfw3.a"

    # glfw 3.5 references `CAMetalLayer` directly, so static links need QuartzCore
    if OS.mac?
      inreplace "vendor/glfw/bindings/bindings.odin", "\"../lib/darwin/libglfw3.a\",",
                "\\0\n\t\t\t\"system:QuartzCore.framework\","
    end

    raylib = Formula["raylib"]
    vendor = buildpath/"vendor/raylib"

    # Odin's `vendor:raylib` bindings link raylib from fixed per-OS/arch dirs
    raylib_dir = if OS.mac?
      "macos"
    elsif Hardware::CPU.arm?
      "linux-arm64"
    else
      "linux"
    end

    ln_s raylib.lib/"libraylib.a", vendor/raylib_dir/"libraylib.a"
    ln_s raylib.lib/shared_library("libraylib"), vendor/raylib_dir/shared_library("libraylib", "620")

    # raylib 6.2's bundled glfw references `CAMetalLayer`, so static links need QuartzCore
    if OS.mac?
      inreplace vendor/"raylib.odin", "\"system:Cocoa.framework\",",
                "\\0\n\t\t\"system:QuartzCore.framework\","
    end

    raygui_dir = vendor/(OS.mac? ? "macos" : "linux")
    raygui_name = (OS.mac? && Hardware::CPU.arm?) ? "libraygui-arm64" : "libraygui"

    resource("raygui").stage do
      cp "src/raygui.h", "src/raygui.c"

      system ENV.cc, "-c", "-o", "raygui.o", "src/raygui.c",
        "-fpic", "-DRAYGUI_IMPLEMENTATION", "-I#{raylib.include}"
      system "ar", "-rcs", "#{raygui_name}.a", "raygui.o"
      cp "#{raygui_name}.a", raygui_dir

      args = [
        "-o", shared_library(raygui_name),
        "src/raygui.c",
        "-shared",
        "-fpic",
        "-DRAYGUI_IMPLEMENTATION",
        "-lm", "-lpthread", "-ldl",
        "-I#{raylib.include}",
        "-L#{raylib.lib}",
        "-lraylib"
      ]
      args += ["-framework", "OpenGL"] if OS.mac?
      system ENV.cc, *args
      cp shared_library(raygui_name), raygui_dir
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
    # raylib's bindings link libX11 on Linux; make it loadable at runtime.
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["libx11"].lib if OS.linux?
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

__END__
--- a/vendor/raylib/raygui.odin
+++ b/vendor/raylib/raygui.odin
@@ -10,8 +10,9 @@
 		"windows/rayguidll.lib" when RAYGUI_SHARED else "windows/raygui.lib",
 	}
 } else when ODIN_OS == .Linux  {
-	// No raygui libs are shipped for Linux: they depend on the glibc of the machine that builds them.
-	foreign import lib "system:raygui"
+	foreign import lib {
+		"linux/libraygui.so" when RAYGUI_SHARED else "linux/libraygui.a",
+	}
 } else when ODIN_OS == .Darwin {
 	when ODIN_ARCH == .arm64 {
 		foreign import lib {
