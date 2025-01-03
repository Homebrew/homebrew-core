class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-24.3.2.tar.xz"
  sha256 "ad9f5f3a6d2169e4786254ee6eb5062f746d11b826739291205d360f1f3ff716"
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
    depends_on "wayland"
    depends_on "zstd"
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

  patch do
    url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/e89eba0796b3469f1d2cdbb600309f6231a8169d.diff"
    sha256 "200de60b79594053c8b5702ddfd4784e760c533c18bfbd9bc219c4039e5c71f3"
  end

  patch do
    url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/c1d94cf5e1ed08a51299625bc453ce2096fd5477.diff"
    sha256 "c827e87be892e3701f09f64a3c12f1caa35e40e6800ea69257550bff1b11be0d"
  end

  patch do
    url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/c779555d820cf7b80f8e982a01a026235532542b.diff"
    sha256 "94d324a13bf724742d1679e477eb7973aa6b2a186a90c077c63662ff980f0114"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources.reject { |r| OS.mac? && r.name == "ply" }
    ENV.prepend_path "PYTHONPATH", venv.site_packages
    ENV.prepend_path "PATH", venv.root/"bin"

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
