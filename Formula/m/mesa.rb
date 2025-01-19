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
    url "https://mesa.freedesktop.org/archive/mesa-24.3.3.tar.xz"
    sha256 "105afc00a4496fa4d29da74e227085544919ec7c86bd92b0b6e7fcc32c7125f4"

    patch do
      url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/48ebbe27779f2576f72aef9eed13c4e4da1115b3.diff"
      sha256 "c827e87be892e3701f09f64a3c12f1caa35e40e6800ea69257550bff1b11be0d"
    end

    patch do
      url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/20b806284aa93c9764b85397e638627d1fafcf18.diff"
      sha256 "94d324a13bf724742d1679e477eb7973aa6b2a186a90c077c63662ff980f0114"
    end

    patch do
      url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/e89eba0796b3469f1d2cdbb600309f6231a8169d.diff"
      sha256 "200de60b79594053c8b5702ddfd4784e760c533c18bfbd9bc219c4039e5c71f3"
    end

    patch do
      url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/568a4ca899762fe96fc9b34d2288d07e6656af87.diff"
      sha256 "cbc7ef81c1c8c91a8d06dad53b3bb6af7d058698a226cddc1315f3ba668d07a9"
    end

    patch do
      url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/191d7c6cb617a3f5ea85d98ae0b8640d0ba60a75.diff"
      sha256 "485bedca1878b4490b5acb29965e024caefd0f21a3edf2f181693843965f5c89"
    end
  end

  bottle do
    sha256 arm64_sequoia: "59d25f8ac493c61555438878dd9488b3ec7ede62aacc7306f689a6997c32cf14"
    sha256 arm64_sonoma:  "9924126d64e4933dbdddd6fcf94bcf3d03552e4b0c5e83d402adf6e7c195f49d"
    sha256 arm64_ventura: "126e0420f890a18fca9007e5c84e78c757144467c204b54695e9c100309991de"
    sha256 sonoma:        "f06a41a3cdfda318809abeff6441638e49897f8260f26f1895b1ac226d9f9ae9"
    sha256 ventura:       "6eb15ed0640b9324b26b24659c36a6669fb823b463791d75dd7dcf3ffc885ec1"
    sha256 x86_64_linux:  "85a6f29e14a8b813b6c7f8edade7bb850e630656220682f6f4c137bd5f44152f"
  end

  depends_on "bindgen" => :build
  depends_on "bison" => :build # can't use from macOS, needs '> 2.3'
  depends_on "cbindgen" => :build
  depends_on "glslang" => :build
  depends_on "libxrandr" => :build
  depends_on "libxshmfence" => :build
  depends_on "libyaml" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "rust" => :build
  depends_on "xorgproto" => :build

  depends_on "expat"
  depends_on "libclc"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxrender"
  depends_on "llvm"
  depends_on "spirv-llvm-translator"
  depends_on "spirv-tools"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "directx-headers" => :build
    depends_on "elfutils" => :build
    depends_on "libva" => :build
    depends_on "libvdpau" => :build
    depends_on "libxml2" => :build # not used on macOS
    depends_on "valgrind" => :build
    depends_on "wayland-protocols" => :build

    depends_on "gzip"
    depends_on "libdrm"
    depends_on "libxv"
    depends_on "libxxf86vm"
    depends_on "lm-sensors"
    depends_on "valgrind"
    depends_on "wayland"
    depends_on "zstd"

    resource "crate-equivalent" do
      url "https://crates.io/api/v1/crates/equivalent/1.0.1/download"
      sha256 "5443807d6dff69373d433ab9ef5378ad8df50ca6298caf15de6e52e24aaf54d5"
    end

    resource "crate-hashbrown" do
      url "https://crates.io/api/v1/crates/hashbrown/0.14.1/download"
      sha256 "7dfda62a12f55daeae5015f81b0baea145391cb4520f86c248fc615d72640d12"
    end

    resource "crate-indexmap" do
      url "https://crates.io/api/v1/crates/indexmap/2.2.6/download"
      sha256 "168fb715dda47215e360912c096649d23d58bf392ac62f73919e831745e40f26"
    end

    resource "crate-once_cell" do
      url "https://crates.io/api/v1/crates/once_cell/1.8.0/download"
      sha256 "692fcb63b64b1758029e0a96ee63e049ce8c5948587f2f7208df04625e5f6b56"
    end

    resource "crate-paste" do
      url "https://crates.io/api/v1/crates/paste/1.0.14/download"
      sha256 "de3145af08024dea9fa9914f381a17b8fc6034dfb00f3a84013f7ff43f29ed4c"
    end

    resource "crate-pest" do
      url "https://crates.io/api/v1/crates/pest/2.7.11/download"
      sha256 "cd53dff83f26735fdc1ca837098ccf133605d794cdae66acfc2bfac3ec809d95"
    end

    resource "crate-pest_derive" do
      url "https://crates.io/api/v1/crates/pest_derive/2.7.11/download"
      sha256 "2a548d2beca6773b1c244554d36fcf8548a8a58e74156968211567250e48e49a"
    end

    resource "crate-pest_generator" do
      url "https://crates.io/api/v1/crates/pest_generator/2.7.11/download"
      sha256 "3c93a82e8d145725dcbaf44e5ea887c8a869efdcc28706df2d08c69e17077183"
    end

    resource "crate-pest_meta" do
      url "https://crates.io/api/v1/crates/pest_meta/2.7.11/download"
      sha256 "a941429fea7e08bedec25e4f6785b6ffaacc6b755da98df5ef3e7dcf4a124c4f"
    end

    resource "crate-proc-macro2" do
      url "https://crates.io/api/v1/crates/proc-macro2/1.0.86/download"
      sha256 "5e719e8df665df0d1c8fbfd238015744736151d4445ec0836b8e628aae103b77"
    end

    resource "crate-quote" do
      url "https://crates.io/api/v1/crates/quote/1.0.33/download"
      sha256 "5267fca4496028628a95160fc423a33e8b2e6af8a5302579e322e4b520293cae"
    end

    resource "crate-roxmltree" do
      url "https://crates.io/api/v1/crates/roxmltree/0.20.0/download"
      sha256 "6c20b6793b5c2fa6553b250154b78d6d0db37e72700ae35fad9387a46f487c97"
    end

    resource "crate-syn" do
      url "https://crates.io/api/v1/crates/syn/2.0.68/download"
      sha256 "901fa70d88b9d6c98022e23b4136f9f3e54e4662c3bc1bd1d84a42a9a0f0c1e9"
    end

    resource "crate-ucd-trie" do
      url "https://crates.io/api/v1/crates/ucd-trie/0.1.6/download"
      sha256 "ed646292ffc8188ef8ea4d1e0e0150fb15a5c2e12ad9b8fc191ae7a8a7f3c4b9"
    end

    resource "crate-unicode-ident" do
      url "https://crates.io/api/v1/crates/unicode-ident/1.0.12/download"
      sha256 "3354b9ac3fae1ff6755cb6db53683adb661634f67557942dea4facebec0fee4b"
    end
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5f/d9/8518279534ed7dace1795d5a47e49d5299dd0994eed1053996402a8902f9/mako-1.3.8.tar.gz"
    sha256 "577b97e414580d3e088d47c2dbbe9594aa7a5146ed2875d4dfa9075af2dd3cc8"
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
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources.reject { |r| (OS.mac? && r.name == "ply") || r.name =~ /^crate/ }
    ENV.prepend_path "PYTHONPATH", venv.site_packages
    ENV.prepend_path "PATH", venv.root/"bin"

    if OS.linux?
      resources.select { |r| r.name =~ /^crate/ }.each { |r| r.stage(buildpath/r.name.gsub("crate-", "")) }
      ENV["MESON_PACKAGE_CACHE_DIR"] = buildpath
    end

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
        -Dtools=all
        -Dvalgrind=enabled
        -Dvulkan-drivers=auto
        -Dvulkan-layers=device-select,intel-nullhw,overlay,screenshot
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
    flags = %W[
      -I#{include}
      -L#{lib}
      -L#{Formula["libx11"].lib}
      -L#{Formula["libxext"].lib}
      -lGL
      -lX11
      -lXext
      -lm
    ]
    system ENV.cc, "glxgears.c", "-o", "gears", *flags
  end
end
