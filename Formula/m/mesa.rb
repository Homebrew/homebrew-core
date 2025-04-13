class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://archive.mesa3d.org/mesa-25.0.3.tar.xz"
  sha256 "5ff426ed6ce0588fd96d18975bdff451ae2ab2fe98b5d1528842ee71ec66711b"
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
    sha256 arm64_sequoia: "20ef139b1b2bf8c241b050e32adf3257454a6fcd720c8edde6afafb54d3efee2"
    sha256 arm64_sonoma:  "d3dbac5ced158853a58d52185409de8a728f0e85473e09cdb3da6b43e8f4607b"
    sha256 arm64_ventura: "76f044bde4461e2d1474f07f02ee00c342879fc578561b916b72e0583c4b4b56"
    sha256 sonoma:        "c0dd4f775ad3ba935beccb4ff5880f05e385ee1c5f86ef48b8e0d6f447fe1fba"
    sha256 ventura:       "1f34b6fd57f3f35e643ae9af4d980dd697892ecdbf73e78d9ba255a9673090cd"
    sha256 arm64_linux:   "758a414828ca52d42ec9412910ef61d114bcd77a9f4a8b6021bfd5abd082ab26"
    sha256 x86_64_linux:  "5cd387e8d900ede2c1af59b083a3d7de2e5ea61b4ca8dfe367950ff7d3c57b8d"
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
    url "https://files.pythonhosted.org/packages/62/4f/ddb1965901bc388958db9f0c991255b2c469349a741ae8c9cd8a562d70a6/mako-1.3.9.tar.gz"
    sha256 "b5d65ff3462870feec922dbccf38f6efb44e5714d7b593a656be86663d8600ac"
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
