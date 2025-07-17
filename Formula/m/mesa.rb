class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
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
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  stable do
    url "https://archive.mesa3d.org/mesa-25.2.0-rc3.tar.xz"
    sha256 "822fd601eeed76c964f57fea828d4fd94c5c2ba548528aa1f584d4c8bc67c1cc"

    on_macos do
      # The following 3 patches are fixing macOS regressions and come from this MR https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/36495
      patch do
        url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/c5ff1088e04eef617f379e554df518908ccfcb9c.diff"
        sha256 "581521fe4d12965eee7e6c194f6e1af3ff1ca7f20e7ebc0d5895e174ab43cc1f"
      end

      patch do
        url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/ea67db08b31afe1af7963e4bb44a62d34da16989.diff"
        sha256 "7d237e37c4c32a70445dbba4d0076ca3618d216a18f5c343f795a0ca409333cf"
      end

      patch do
        url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/b635652941110c9621aff10fa7bc102b32cea637.diff"
        sha256 "2b76652c697c8274cd4d46bc90a03bc034f85a2635dcd406a155d5acde00ef76"
      end
    end
  end

  bottle do
    sha256 arm64_sequoia: "e68026fed60bfe45cc49032020773229711644cf00e624e2a1b81bd7aef1ff72"
    sha256 arm64_sonoma:  "7e36ba1f5a3bcf8df5e49577d264d5443b229becfeca831209403bf781997b12"
    sha256 arm64_ventura: "e40a376f566f8d1c13ef98952aef4aedf84e23bc6cd3ad840ec1467db63e7554"
    sha256 sonoma:        "a0df8f9c13d8d0804a01a7d659368320f04a40b79d91d5615817fb0fc55219bf"
    sha256 ventura:       "074c954d164280e15011b52bbe4aafb49a15f25e38febe7e00734d8ac48939b5"
    sha256 arm64_linux:   "dd2a27631e4413c49c023f6dd6c35ed5e50f6fed3a5d66da71cfed028d374e13"
    sha256 x86_64_linux:  "3e01c0fff41e0024dd2193764e5e259049632fbc52fc4c216b6e6680b7b2ffce"
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
  depends_on "python@3.13" => :build
  depends_on "rust" => :build
  depends_on "xorgproto" => :build

  depends_on "libclc" # OpenCL support needs share/clc/*.bc files at runtime
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "llvm"
  depends_on "spirv-llvm-translator"
  depends_on "spirv-tools"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "directx-headers" => :build
    depends_on "gzip" => :build
    depends_on "libva" => :build
    depends_on "libvdpau" => :build
    depends_on "valgrind" => :build
    depends_on "wayland-protocols" => :build

    depends_on "elfutils"
    depends_on "libdrm"
    depends_on "libxml2" # not used on macOS
    depends_on "libxshmfence"
    depends_on "libxxf86vm"
    depends_on "lm-sensors"
    depends_on "wayland"

    on_arm do
      depends_on "pycparser" => :build
    end

    on_intel do
      depends_on "cbindgen" => :build
    end
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def python3
    "python3.13"
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
      -Dopengl=true
      -Dstrip=true
      -Dllvm=enabled

      -Dvideo-codecs=all
      -Dgallium-rusticl=true
    ]
    args += if OS.mac?
      %W[
        -Dgallium-drivers=llvmpipe,zink
        -Dvulkan-drivers=swrast
        -Dvulkan-layers=intel-nullhw,overlay,screenshot
        -Dtools=etnaviv,glsl,nir,nouveau,imagination,dlclose-skip
        -Dmoltenvk-dir=#{Formula["molten-vk"].prefix}
      ]
    else
      %w[
        -Degl=enabled
        -Dgallium-drivers=auto
        -Dgallium-extra-hud=true
        -Dgallium-va=enabled
        -Dgallium-vdpau=enabled
        -Dgbm=enabled
        -Dgles1=enabled
        -Dgles2=enabled
        -Dglx=dri
        -Dintel-clc=enabled
        -Dlmsensors=enabled
        -Dmicrosoft-clc=disabled
        -Dplatforms=x11,wayland
        -Dtools=drm-shim,dlclose-skip,etnaviv,freedreno,glsl,intel,lima,nir,nouveau,asahi,imagination
        -Dvalgrind=enabled
        -Dvulkan-drivers=auto
        -Dvulkan-layers=device-select,intel-nullhw,overlay,screenshot
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
      ] do |s|
        s.gsub! ".so", ".dylib"
      end
    end
  end

  test do
    resource "glxgears.c" do
      url "https://gitlab.freedesktop.org/mesa/demos/-/raw/8ecad14b04ccb3d4f7084122ff278b5032afd59a/src/xdemos/glxgears.c"
      sha256 "cbb5a797cf3d2d8b3fce01cfaf01643d6162ca2b0e97d760cc2e5aec8d707601"
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
