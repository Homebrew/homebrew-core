class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  license "MIT"
  revision 1
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  stable do
    url "https://mesa.freedesktop.org/archive/mesa-22.1.7.tar.xz"
    sha256 "da838eb2cf11d0e08d0e9944f6bd4d96987fdc59ea2856f8c70a31a82b355d89"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/f0a40cf7d70ee5a25639b91d9a8088749a2dd04e/mesa/fix-build-on-macOS.patch"
      sha256 "a9b646e48d4e4228c3e06d8ca28f65e01e59afede91f58d4bd5a9c42a66b338d"
    end
  end

  bottle do
    sha256 arm64_monterey: "3cd290cfffcef57bfc52c28c474b783a6fe9f12922ebb9b864e7b4ec2867d43e"
    sha256 arm64_big_sur:  "10e4a4193279dd1c67b01062c02b422c95992c91cfe64b31438e227272ecac5c"
    sha256 monterey:       "5533f253ca94226b150e3336f7521453887417857318d4f6cf1a5f992fbd16f9"
    sha256 big_sur:        "82adabd05d92b04a993c9f1dcc5b199e713ea6e7dca559a75a696f059a6052c4"
    sha256 catalina:       "deff2857c129774a22f61195333e809d61e3d370d16cdd1e11d3f8881f913c2d"
    sha256 x86_64_linux:   "9ea27491a9f619b6b85fe353a248cfde70bb211fcbaa8a65b204f1cfc6655fa4"
  end

  depends_on "bison" => :build # can't use form macOS, needs '> 2.3'
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
    depends_on "gcc"
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
    url "https://files.pythonhosted.org/packages/ad/dd/34201dae727bb183ca14fd8417e61f936fa068d6f503991f09ee3cac6697/Mako-1.2.1.tar.gz"
    sha256 "f054a5ff4743492f1aa9ecc47172cb33b42b9d993cffcc146c9de17e717b0307"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
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
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

    venv_root = buildpath/"venv"
    venv = virtualenv_create(venv_root, "python3")

    %w[Mako Pygments MarkupSafe].each do |res|
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
