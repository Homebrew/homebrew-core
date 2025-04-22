class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://archive.mesa3d.org/mesa-25.0.4.tar.xz"
  sha256 "76293cf4372ca4e4e73fd6c36c567b917b608a4db9d11bd2e33068199a7df04d"
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

  bottle do
    sha256 arm64_sequoia: "5406d012ed2cb39b785b5c0ca80b3d28371697902fc113df049a4a61011d171d"
    sha256 arm64_sonoma:  "aee698de0d3929b35da1d8d1ae07d2473543434e4943948ea825ce7043b9b4c4"
    sha256 arm64_ventura: "dbb48f1ceb23a9caacbeed123f290345deee96858d1aeb0692f59ca11bc97e0b"
    sha256 sonoma:        "2266f1abbcf183cdb9d55a7b9cdabe7e01cd27bae268165cdcc291ac25aaeeae"
    sha256 ventura:       "b86bc5e41de06a70e62c44810dba686d2abd56c307e85eb379c5e61eb69b06d0"
    sha256 arm64_linux:   "7386ab3cff93363ac92c2af4139bf010ce6aa169ed601f933a475ac82eea3900"
    sha256 x86_64_linux:  "90a1af14d62c6a9a6cf73615daeaf1cbbec25caef4834c17e9fe72c3b99efd65"
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
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
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
      -Dosmesa=true
      -Dstrip=true
      -Dllvm=enabled
      -Dgallium-drivers=auto
      -Dvideo-codecs=all
      -Dgallium-opencl=icd
      -Dgallium-rusticl=true
    ]
    args += if OS.mac?
      %w[
        -Dvulkan-drivers=swrast
        -Dvulkan-layers=intel-nullhw,overlay,screenshot
        -Dtools=etnaviv,glsl,nir,nouveau,asahi,imagination,dlclose-skip
      ]
    else
      %w[
        -Degl=enabled
        -Dgallium-extra-hud=true
        -Dgallium-nine=true
        -Dgallium-va=enabled
        -Dgallium-vdpau=enabled
        -Dgallium-xa=enabled
        -Dgbm=enabled
        -Dgles1=enabled
        -Dgles2=enabled
        -Dglx=dri
        -Dintel-clc=enabled
        -Dlmsensors=enabled
        -Dmicrosoft-clc=disabled
        -Dplatforms=x11,wayland
        -Dshared-glapi=enabled
        -Dtools=drm-shim,dlclose-skip,etnaviv,freedreno,glsl,intel,lima,nir,nouveau,asahi,imagination
        -Dvalgrind=enabled
        -Dvulkan-drivers=auto
        -Dvulkan-layers=device-select,intel-nullhw,overlay,screenshot
        --force-fallback-for=indexmap,paste,pest_generator,roxmltree,syn
      ]
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    prefix.install "docs/license.rst"
    inreplace lib/"pkgconfig/dri.pc" do |s|
      s.change_make_var! "dridriverdir", HOMEBREW_PREFIX/"lib/dri"
    end
  end

  test do
    resource "glxgears.c" do
      url "https://gitlab.freedesktop.org/mesa/demos/-/raw/878cd7fb84b7712d29e5d1b38355ed9c5899a403/src/xdemos/glxgears.c"
      sha256 "af7927d14bd9cc989347ad0c874b35c4bfbbe9f408956868b1c5564391e21eed"
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
