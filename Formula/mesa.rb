class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  stable do
    url "https://mesa.freedesktop.org/archive/mesa-22.2.4.tar.xz"
    sha256 "65d76b53ca5c7b46019e0e8e5b414de45d2fecd3fcd71707f6c3bc7691c9f7ab"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/f0a40cf7d70ee5a25639b91d9a8088749a2dd04e/mesa/fix-build-on-macOS.patch"
      sha256 "a9b646e48d4e4228c3e06d8ca28f65e01e59afede91f58d4bd5a9c42a66b338d"
    end
  end

  bottle do
    sha256 arm64_ventura:  "0e51503327aa8b10c1722a14ca204a588e729f7248cdbb3b993c1c2a7650f853"
    sha256 arm64_monterey: "b6b2c74644de233f763ebe804cd82928bde11249582d6600585cba16fb6003c3"
    sha256 arm64_big_sur:  "a1e1b345d97597781518782015e56c7870beb2f6a42f0a7c2dc33c72a8663c66"
    sha256 ventura:        "ff1e0d3f6cea874752d6e7b5f47c0d6e37a2d7c123f4a324d54e6e65c112a194"
    sha256 monterey:       "fb8532b58035a362a0a07b6ad11601f8e3ea861db20ae045756015c38869d314"
    sha256 big_sur:        "52cb74ff1b1287b15e978fd88bbfa361bac95be070db5addce4eb410a111a940"
    sha256 catalina:       "0329c1d3f75fd8cfd22035c070e4876ee67d7eeda5b98f0080ab0b669b02945c"
    sha256 x86_64_linux:   "454a44dd4d8ed31f8a6c556b0c579dde1c7f0639984971f1c582f3b06b68ed66"
  end

  depends_on "bison" => :build # can't use form macOS, needs '> 2.3'
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pygments" => :build
  depends_on "python@3.10" => :build
  depends_on "xorgproto" => :build

  depends_on "expat"
  depends_on "gettext"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxdamage"
  depends_on "libxext"

  uses_from_macos "flex" => :build
  uses_from_macos "llvm"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
    depends_on "glslang"
    depends_on "gzip"
    depends_on "libdrm"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libxfixes"
    depends_on "libxrandr"
    depends_on "libxshmfence"
    depends_on "libxv"
    depends_on "libxvmc"
    depends_on "libxxf86vm"
    depends_on "lm-sensors"
    depends_on "wayland"
    depends_on "wayland-protocols"
  end

  fails_with gcc: "5"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "glxgears.c" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/db5ad06a346774a249b22797e660d55bde0d9571/src/xdemos/glxgears.c"
    sha256 "3873db84d708b5d8b3cac39270926ba46d812c2f6362da8e6cd0a1bff6628ae6"
  end

  resource "gl_wrap.h" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/ddc35ca0ea2f18c5011c5573b4b624c128ca7616/src/util/gl_wrap.h"
    sha256 "41f5a84f8f5abe8ea2a21caebf5ff31094a46953a83a738a19e21c010c433c88"
  end

  def install
    venv_root = buildpath/"venv"
    venv = virtualenv_create(venv_root, "python3.10")

    %w[Mako MarkupSafe].each do |res|
      venv.pip_install resource(res)
    end

    ENV.prepend_path "PATH", "#{venv_root}/bin"

    args = ["-Db_ndebug=true"]

    if OS.linux?
      args += %w[
        -Dplatforms=x11,wayland
        -Dglx=auto
        -Ddri3=true
        -Dgallium-drivers=auto
        -Dgallium-omx=disabled
        -Degl=true
        -Dgbm=true
        -Dopengl=true
        -Dgles1=enabled
        -Dgles2=enabled
        -Dgallium-xvmc=disabled
        -Dvalgrind=false
        -Dtools=drm-shim,etnaviv,freedreno,glsl,nir,nouveau,xvmc,lima
      ]
    end

    system "meson", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
    inreplace lib/"pkgconfig/dri.pc" do |s|
      s.change_make_var! "dridriverdir", HOMEBREW_PREFIX/"lib/dri"
    end

    if OS.linux?
      # Strip executables/libraries/object files to reduce their size
      system("strip", "--strip-unneeded", "--preserve-dates", *(Dir[bin/"**/*", lib/"**/*"]).select do |f|
        f = Pathname.new(f)
        f.file? && (f.elf? || f.extname == ".a")
      end)
    end
  end

  test do
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
