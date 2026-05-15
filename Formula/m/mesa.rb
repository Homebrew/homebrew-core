class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://archive.mesa3d.org/mesa-26.0.6.tar.xz"
  sha256 "1d3c3b8a8363b8cc354175bb4a684ad8b035211cc1d6fa17aeb9b9623c513f89"
  license all_of: [
    "MIT",
    "Apache-2.0", # include/{EGL,GLES*,vk_video,vulkan}, src/egl/generate/egl.xml, src/mapi/glapi/registry/gl.xml
    "BSD-2-Clause", # src/asahi/lib/dyld_interpose.h, src/getopt/getopt*, src/util/xxhash.h
    "BSD-3-Clause", # src/compiler/glsl/float64.glsl, src/util/softfloat.*
    "BSL-1.0", # src/c11, src/gallium/auxiliary/gallivm/f.cpp
    "HPND", # src/mesa/x86/assyntax.h
    "HPND-sell-variant", # src/loader/loader_{dri,dri3,wayland}_helper.*, src/vulkan/wsi/wsi_common_display.*
    "ICU", # src/glx/*
    "MIT-Khronos-old", # src/compiler/spirv/{GLSL.*,OpenCL.std.h,spirv.core.grammar.json,spirv.h}
    "SGI-B-2.0", # src/glx/*
    :public_domain, # src/util/{dbghelp.h,u_atomic.h,sha1}, src/util/perf/gpuvis_trace_utils.h
    { "GPL-1.0-or-later" => { with: "Linux-syscall-note" } }, # include/drm-uapi/sync_file.h
    { "GPL-2.0-only" => { with: "Linux-syscall-note" } }, # include/drm-uapi/{d3dkmthk.h,dma-buf.h,etnaviv_drm.h}
  ]
  compatibility_version 1
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "335d2077f4cef9e76a4cca69f4c26e0ef1a77d229ae863dd6d1f529dfea36dd0"
    sha256 arm64_sequoia: "186ff2d377484c6c2812f0e0f7a7811211694d713b7752ee22f2e4205b776410"
    sha256 arm64_sonoma:  "41121311e549a7c22b40ed97e8e67fb41cbedc28921277e58531c4e09666ae90"
    sha256 sonoma:        "6b59d53d5de07ecd7e05105cf97423284098e9b35643ca16b5e3f9b2c7d12118"
    sha256 arm64_linux:   "372547e0b8e7fa4717ff6e26a97562bffba776143c65f9b60ef4f206765e9158"
    sha256 x86_64_linux:  "41dc2b8413b3d874046215cc32be806f03a4abb2f977e2e29f3f2dac2ef35f57"
  end

  depends_on "bindgen" => :build
  depends_on "bison" => :build # can't use from macOS, needs '> 2.3'
  depends_on "glslang" => :build
  depends_on "libxrandr" => :build
  depends_on "libxrender" => :build
  depends_on "libxshmfence" => :build
  depends_on "libyaml" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "xorgproto" => :build

  depends_on "libclc" => :no_linkage # OpenCL support needs share/clc/*.bc files at runtime
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "llvm"
  depends_on "spirv-llvm-translator"
  depends_on "spirv-tools"
  depends_on "xcb-util-keysyms"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "expat"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "directx-headers" => :build
    depends_on "gzip" => :build
    depends_on "libva" => :build
    depends_on "pycparser" => :build
    depends_on "valgrind" => :build
    depends_on "wayland-protocols" => :build

    depends_on "libdrm"
    depends_on "libxml2" # not used on macOS
    depends_on "libxshmfence"
    depends_on "libxxf86vm"
    depends_on "lm-sensors"
    depends_on "wayland"
    depends_on "zlib-ng-compat"

    on_intel do
      depends_on "cbindgen" => :build
      depends_on "elfutils"
    end
  end

  pypi_packages package_name:   "",
                extra_packages: %w[mako packaging ply pyyaml]

  resource "mako" do
    url "https://files.pythonhosted.org/packages/00/62/791b31e69ae182791ec67f04850f2f062716bbd205483d63a215f3e062d3/mako-1.3.12.tar.gz"
    sha256 "9f778e93289bd410bb35daadeb4fc66d95a746f0b75777b942088b7fd7af550a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def python3
    "python3.14"
  end

  def install
    # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
    # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
    # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
    if OS.mac? && MacOS.version < :sequoia
      env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
      ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
      ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
    end

    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources.reject { |r| OS.mac? && r.name == "ply" }
    ENV.prepend_path "PYTHONPATH", venv.site_packages
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}" if OS.mac?

    args = %w[
      -Db_ndebug=true
      -Dgallium-rusticl=true
      -Dllvm=enabled
      -Dopengl=true
      -Dstrip=true
      -Dvideo-codecs=all
    ]
    args += if OS.mac?
      # Work around .../rusticl_system_bindings.h:1:10: fatal error: 'stdio.h' file not found
      ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path

      vulkan_drivers = (MacOS.version >= :sequoia) ? "kosmickrisp,swrast" : "swrast"

      %W[
        -Dgallium-drivers=llvmpipe,zink
        -Dmoltenvk-dir=#{Formula["molten-vk"].prefix}
        -Dtools=etnaviv,glsl,nir,nouveau,dlclose-skip
        -Dvulkan-drivers=#{vulkan_drivers}
        -Dvulkan-layers=intel-nullhw,overlay,screenshot,vram-report-limit
      ]
    else
      # Not all supported drivers are being auto-enabled on x86 Linux.
      # TODO: Determine the explicit drivers list for ARM Linux.
      drivers = Hardware::CPU.intel? ? "all" : "auto"

      %W[
        -Degl=enabled
        -Dgallium-drivers=#{drivers}
        -Dgallium-extra-hud=true
        -Dgallium-va=enabled
        -Dgbm=enabled
        -Dgles1=enabled
        -Dgles2=enabled
        -Dglx=dri
        -Dintel-rt=enabled
        -Dlmsensors=enabled
        -Dmicrosoft-clc=disabled
        -Dplatforms=x11,wayland
        -Dtools=drm-shim,etnaviv,freedreno,glsl,intel,nir,nouveau,lima,panfrost,asahi,imagination,dlclose-skip
        -Dvalgrind=enabled
        -Dvulkan-drivers=#{drivers}
        -Dvulkan-layers=device-select,intel-nullhw,overlay,screenshot,vram-report-limit
        --force-fallback-for=indexmap,paste,pest_generator,roxmltree,rustc-hash,syn
      ]
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    prefix.install "docs/license.rst"
    inreplace lib/"pkgconfig/dri.pc" do |s|
      s.change_make_var! "dridriverdir", HOMEBREW_PREFIX/"lib/dri"
    end

    # https://gitlab.freedesktop.org/mesa/mesa/-/issues/13119
    if OS.mac?
      inreplace %W[
        #{prefix}/etc/OpenCL/vendors/rusticl.icd
        #{share}/vulkan/explicit_layer.d/VkLayer_MESA_overlay.json
        #{share}/vulkan/explicit_layer.d/VkLayer_MESA_screenshot.json
        #{share}/vulkan/explicit_layer.d/VkLayer_MESA_vram_report_limit.json
      ] do |s|
        s.gsub! ".so", ".dylib"
      end
    end
  end

  test do
    resource "glxgears.c" do
      url "https://gitlab.freedesktop.org/mesa/demos/-/raw/a533acd00ed0b6d1beda7df0c68a59a873dba2b3/src/xdemos/glxgears.c"
      sha256 "36376674e73fb0657fd56a3738c330b828da6731c934e2b29d75253dc02ad03b"
    end

    resource "gl_wrap.h" do
      url "https://gitlab.freedesktop.org/mesa/demos/-/raw/ddc35ca0ea2f18c5011c5573b4b624c128ca7616/src/util/gl_wrap.h"
      sha256 "41f5a84f8f5abe8ea2a21caebf5ff31094a46953a83a738a19e21c010c433c88"
    end

    %w[glxgears.c gl_wrap.h].each { |r| resource(r).stage(testpath) }
    flags = shell_output("pkgconf --cflags --libs gl x11 xext").chomp.split
    system ENV.cc, "glxgears.c", "-o", "gears", *flags, "-lm"
  end
end
