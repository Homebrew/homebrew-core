class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2026-11a",
      revision: "9a6991685ddf663956d9836602eb421e141fc443"
  version "2026-11a"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "e6a2baf4427bfb5faeadc560bd2a087874f2dd6d1693fa502ff74bcfe871bca1"
    sha256               arm64_tahoe:       "0463e3a3fee6de64e6aaef9111513a67b7e6368ab42f69ff1336790daaa43a13"
    sha256               arm64_sequoia:     "4f58ae245018abd88abdadaddc7db4c09b86194301e91a5c54876b9e9a85707b"
    sha256 cellar: :any, arm64_linux:       "2a9c856d6fdc49fae438d3d9b704b39ba0e054ed19eaf63f62efd77eeac3d369"
    sha256 cellar: :any, x86_64_linux:      "356978ce5bb9373813d735a2c978653c34cc8a40229d943006fc94898ec82879"
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
