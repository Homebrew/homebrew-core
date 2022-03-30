class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-22.0.1.tar.xz"
  sha256 "c05f9682c54560b36e0afa70896233fc73f1ed715e10d1a028b0eb84fd04426f"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "c5cfedf16c3e0592f4b5a1f3fc23f37a9609a86498756427886f81f88c285d62"
    sha256 arm64_big_sur:  "8e1b2f4ffb6de6bc3eb5da5c4af8b061f12d37105f8d316432d73a9caa0d2305"
    sha256 monterey:       "8d4d7a9f94e706184d32548043d88e702392a340e37eef1aec86c7f502d96c6c"
    sha256 big_sur:        "f1587fa8177ce3966fc68cf38f45f421fb241030512db463bf176889b355fbbb"
    sha256 catalina:       "d98f60bfced39e0b2fd7b24fc1842a7bf53c93db4a17b9d7932bcff1461a871c"
    sha256 x86_64_linux:   "5376e48612d5d37e73de0421842bc87c7add1c74a60ecbd49172e30e19924bf3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "expat"
  depends_on "gettext"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxdamage"
  depends_on "libxext"

  uses_from_macos "bison" => :build
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
    url "https://files.pythonhosted.org/packages/50/ec/1d687348f0954bda388bfd1330c158ba8d7dea4044fc160e74e080babdb9/Mako-1.2.0.tar.gz"
    sha256 "9a7c7e922b87db3686210cf49d5d767033a41d4010b284e747682c92bddd8b39"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "glxgears.c" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/faaa319d704ac677c3a93caadedeb91a4a74b7a7/src/xdemos/glxgears.c"
    sha256 "3873db84d708b5d8b3cac39270926ba46d812c2f6362da8e6cd0a1bff6628ae6"
  end

  resource "gl_wrap.h" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/faaa319d704ac677c3a93caadedeb91a4a74b7a7/src/util/gl_wrap.h"
    sha256 "c727b2341d81c2a1b8a0b31e46d24f9702a1ec55c8be3f455ddc8d72120ada72"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

    venv_root = buildpath/"venv"
    venv = virtualenv_create(venv_root, "python3")

    %w[Mako Pygments MarkupSafe].each do |res|
      venv.pip_install resource(res)
    end

    ENV.prepend_path "PATH", "#{venv_root}/bin"

    mkdir "build" do
      args = ["-Db_ndebug=true"]

      if OS.linux?
        args << "-Dplatforms=x11,wayland"
        args << "-Dglx=auto"
        args << "-Ddri3=true"
        args << "-Dgallium-drivers=auto"
        args << "-Dgallium-omx=disabled"
        args << "-Degl=true"
        args << "-Dgbm=true"
        args << "-Dopengl=true"
        args << "-Dgles1=enabled"
        args << "-Dgles2=enabled"
        args << "-Dgallium-xvmc=disabled"
        args << "-Dvalgrind=false"
        args << "-Dtools=drm-shim,etnaviv,freedreno,glsl,nir,nouveau,xvmc,lima"
      end

      system "meson", *std_meson_args, "..", *args
      system "ninja"
      system "ninja", "install"
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
