class Mesa < Formula
  include Language::Python::Virtualenv

  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-20.3.2.tar.xz"
  sha256 "cce001b685d23afb976b04138714906abcf7e7f996da6355e6a43e5ca486533d"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "5f27f0ebe825e601032269563dc0952469d717c36330f1f7168132142731818a" => :big_sur
    sha256 "4c13e1d6783317c73e5affe7ff2a1ff70924eea3f0816c562c1b30a5fe187616" => :arm64_big_sur
    sha256 "0e11b188a0f24b12fccbfb7e0a20843ac73bfd4184be0a6c4d1f57e0ff942d7d" => :catalina
    sha256 "5c68d4275cddb201114e2a1f5bf3bba0909e66b5fac3f67388aab0823dcc77eb" => :mojave
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

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/72/89/402d2b4589e120ca76a6aed8fee906a0f5ae204b50e455edd36eda6e778d/Mako-1.1.3.tar.gz"
    sha256 "8195c8c1400ceb53496064314c6736719c6f25e7479cd24c77be3d9361cddc27"
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
    url "https://gitlab.freedesktop.org/mesa/mesa/-/commit/50064ad367449afad03c927f7e572c138b05c5d4.patch"
    sha256 "aa3fa361a8626d442aefdac922a7193612b77cab2410452acee40b6dbc10a800"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    venv_root = libexec/"venv"
    venv = virtualenv_create(venv_root, "python3")
    venv.pip_install resource("Mako")

    ENV.prepend_path "PATH", "#{venv_root}/bin"

    mkdir "build" do
      system "meson", *std_meson_args, "..", "-Db_ndebug=true"
      system "ninja"
      system "ninja", "install"
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
