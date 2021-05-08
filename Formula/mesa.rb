class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://archive.mesa3d.org/mesa-21.0.3.tar.xz"
  sha256 "565c6f4bd2d5747b919454fc1d439963024fc78ca56fd05158c3b2cde2f6912b"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  livecheck do
    url "https://www.mesa3d.org/news/"
    regex(/>\s*Mesa v?(\d+(?:\.\d+)+) is released\s*</i)
  end

  bottle do
    sha256 arm64_big_sur: "bbf7549e32809888991466828171e879e42ce6c43d1cba9d24b5153de7c37b4c"
    sha256 big_sur:       "57e29996782f3f26e1f8acbf80c8f379c80c41c6a4416326feffd2248c5a2b1c"
    sha256 catalina:      "3773091e14cd5edad4eace8704823ef3bbe6f1627c485e89942b41ea859d7c82"
    sha256 mojave:        "eeb3f8757ed4e113e27784cc441182ed32e8a43f50ed064ce11b6e211e9c34db"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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
    depends_on "lm-sensors"
    depends_on "libelf"
    depends_on "libxfixes"
    depends_on "libxrandr"
    depends_on "libxshmfence"
    depends_on "libxv"
    depends_on "libxvmc"
    depends_on "libxxf86vm"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libdrm"
    depends_on "wayland"
    depends_on "wayland-protocols"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/5c/db/2d2d88b924aa4674a080aae83b59ea19d593250bfe5ed789947c21736785/Mako-1.1.4.tar.gz"
    sha256 "17831f0b7087c313c0ffae2bcbbd3c1d5ba9eeac9c38f2eb7b50e8c99fe9d5ab"
  end

  resource "glxgears.c" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/faaa319d704ac677c3a93caadedeb91a4a74b7a7/src/xdemos/glxgears.c"
    sha256 "3873db84d708b5d8b3cac39270926ba46d812c2f6362da8e6cd0a1bff6628ae6"
  end

  resource "gl_wrap.h" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/faaa319d704ac677c3a93caadedeb91a4a74b7a7/src/util/gl_wrap.h"
    sha256 "c727b2341d81c2a1b8a0b31e46d24f9702a1ec55c8be3f455ddc8d72120ada72"
  end

  patch do
    url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/50064ad367449afad03c927f7e572c138b05c5d4.diff"
    sha256 "2f17f8f03a54350025fff65ec6d410b1c2f924a30199551457a0f43a9bada7b6"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    venv_root = libexec/"venv"
    venv = virtualenv_create(venv_root, "python3")
    venv.pip_install resource("Mako")

    ENV.prepend_path "PATH", "#{venv_root}/bin"

    mkdir "build" do
      args = ["-Db_ndebug=true"]

      on_linux do
        args << "-Dplatforms=x11,wayland"
        args << "-Dglx=auto"
        args << "-Ddri3=true"
        args << "-Ddri-drivers=auto"
        args << "-Dgallium-drivers=auto"
        args << "-Dgallium-omx=disabled"
        args << "-Degl=true"
        args << "-Dgbm=true"
        args << "-Dopengl=true"
        args << "-Dgles1=true"
        args << "-Dgles2=true"
        args << "-Dxvmc=true"
        args << "-Dvalgrind=false"
        args << "-Dtools=drm-shim,etnaviv,freedreno,glsl,nir,nouveau,xvmc,lima"
      end

      system "meson", *std_meson_args, "..", *args
      system "ninja"
      system "ninja", "install"
    end

    on_linux do
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
