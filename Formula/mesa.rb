class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-21.3.1.tar.xz"
  sha256 "2b0dc2540cb192525741d00f706dbc4586349185dafc65729c7fda0800cc474d"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "0b24328f86e2ec2abc0b94ff2ad93b6a8e5e9c990da9713080f0afad33c3f30a"
    sha256 arm64_big_sur:  "28d4473154c77c6fd26c5a29291af6b8af2ae4e9b0cba443e2c825bca7fcacad"
    sha256 monterey:       "6d61cc330d58ed3876bb4b9deb6c12272bef628894ccd6d17a6f75bc03b359f8"
    sha256 big_sur:        "4c6846d55c0b46196b5f689ceeafc6dbb4b7ec55f02b68d439f2956533a8817b"
    sha256 catalina:       "0be7bf943d14e317ceb1c380bec5c2f89839654c57d704f2649b5f650b0d3679"
    sha256 x86_64_linux:   "a6d24f2f891c0209c70e2cedc13a152caa3abb652d67393c0ae4f243324398e0"
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
    depends_on "elfutils"
    depends_on "gcc"
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
    url "https://files.pythonhosted.org/packages/af/b6/42cd322ae555aa770d49e31b8c5c28a243ba1bbb57ad927e1a5f5b064811/Mako-1.1.6.tar.gz"
    sha256 "4e9e345a41924a954251b95b4b28e14a301145b544901332e658907a7464b6b2"
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
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    venv_root = libexec/"venv"
    venv = virtualenv_create(venv_root, "python3")
    venv.pip_install resource("Mako")

    ENV.prepend_path "PATH", "#{venv_root}/bin"

    mkdir "build" do
      args = ["-Db_ndebug=true"]

      if OS.linux?
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
