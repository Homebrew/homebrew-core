class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://archive.mesa3d.org/mesa-26.3.0.tar.xz"
  sha256 "91d729aa68bb89e4ec857841300bbe922bcb3e52b1f97566ca83930d3b28343a"
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
    sha256 arm64_golden_gate: "50f68aeab7a2cb37e07bac0ba1227d27bcd156d6c52966d7f8e16fc2933517ee"
    sha256 arm64_tahoe:       "f774ca38347701f9861c1a080e3002b46fc4bbc937d2df73c066f3b68f31c72c"
    sha256 arm64_sequoia:     "c2b4af6ecc9ba7fd9151028a83029a13e1244cd3322f14d707fc410ebacb5ace"
    sha256 arm64_linux:       "88a7a8b5168fadcf1136c64c48f131160dbdb9e592f0a145c309d05868ff42b0"
    sha256 x86_64_linux:      "660a4dd88e42ded5efac67443384355ec219bfc9c96fa350c7ffe15bb38a861a"
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
  depends_on "python-setuptools" => :build
  depends_on "python@3.15" => :build
  depends_on "rust" => :build
  depends_on "xorgproto" => :build

  depends_on "libclc" => :no_linkage # OpenCL support needs libclc.spv files at runtime
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
                extra_packages: %w[flit-core mako packaging ply pyyaml]

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/d3/8b/0370578a456986d6995344967a479dd5c9d4e064681550c2a9594bb58b4a/flit_core-4.2.0.tar.gz"
    sha256 "84e4e4d8fdd45ba2613800a3ebc6834de26d47ec9746efc3719f94181137b460"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "glxgears.c", :test do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/mesa-demos-9.0.0/src/xdemos/glxgears.c"
    sha256 "344a03aff01708350d90603fd6b841bccd295157670f519b459bbf3874acf847"

    livecheck do
      url "https://gitlab.freedesktop.org/mesa/demos.git"
      regex(/^mesa-demos[._-]v?(\d+(?:\.\d+)+)$/i)
    end
  end

  resource "gl_wrap.h", :test do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/mesa-demos-9.0.0/src/util/gl_wrap.h"
    sha256 "41f5a84f8f5abe8ea2a21caebf5ff31094a46953a83a738a19e21c010c433c88"

    livecheck do
      url "https://gitlab.freedesktop.org/mesa/demos.git"
      regex(/^mesa-demos[._-]v?(\d+(?:\.\d+)+)$/i)
    end
  end

  deny_network_access!

  def fetch
    # Fetching all Rust subprojects since Meson doesn't recursively download subprojects
    system "meson", "subprojects", "download", "*-rs"
    # Venus protocol headers moved out of tree in 26.3 and are required by the virtio Vulkan driver
    system "meson", "subprojects", "download", "venus-protocol" if OS.linux?
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources.reject { |r| r.test? || (OS.mac? && r.name == "ply") }, build_isolation: false
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

      # KosmicKrisp requires Metal 4 / macOS 26, see https://docs.mesa3d.org/drivers/kosmickrisp.html
      vulkan_drivers = (MacOS.version >= :tahoe) ? "kosmickrisp,swrast" : "swrast"

      %W[
        -Dgallium-drivers=llvmpipe,zink
        -Dmoltenvk-dir=#{Formula["molten-vk"].prefix}
        -Dtools=etnaviv,glsl,nir,nouveau,dlclose-skip
        -Dvulkan-drivers=#{vulkan_drivers}
        -Dvulkan-layers=intel-nullhw,overlay,screenshot,vram-report-limit
        --force-fallback-for=syn
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
        --force-fallback-for=indexmap,paste,pest_generator,roxmltree,rustc-hash,syn,venus-protocol
      ]
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    prefix.install "docs/license.rst"
    inreplace lib/"pkgconfig/dri.pc" do |s|
      s.change_make_var! "dridriverdir", HOMEBREW_PREFIX/"lib/dri"
    end

    # https://gitlab.freedesktop.org/mesa/mesa/-/work_items/13119
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
    %w[glxgears.c gl_wrap.h].each { |r| resource(r).stage(testpath) }
    flags = shell_output("pkgconf --cflags --libs gl x11 xext").chomp.split
    system ENV.cc, "glxgears.c", "-o", "gears", *flags, "-lm"
  end
end
