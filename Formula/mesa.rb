class Mesa < Formula
  include Language::Python::Virtualenv
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-19.1.5.tar.xz"
  sha256 "7b54e14e35c7251b171b4cf9d84cbc1d760eafe00132117db193454999cd6eb4"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  bottle do
    sha256 "80f51c11c3c9a2c0c060a9d05cb6c3388fbe509bce709110c94db9b43c0fa87e" => :mojave
    sha256 "33c8ff9481a408cbda2c59316816067778ffcbd348005be7fb01421715ad053f" => :high_sierra
    sha256 "4e7daa4156a882f4fe4412d5595413c5e6599021c9a8a56a1763b8065b4a5761" => :sierra
  end

  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "freeglut" => :test
  depends_on "expat"
  depends_on "gettext"
  depends_on :x11

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/f9/93/63f78c552e4397549499169198698de23b559b52e57f27d967690811d16d/Mako-1.0.10.tar.gz"
    sha256 "7165919e78e1feb68b4dbe829871ea9941398178fa58e6beedb9ba14acf63965"
  end

  resource "gears.c" do
    url "https://www.opengl.org/archives/resources/code/samples/glut_examples/mesademos/gears.c"
    sha256 "7df9d8cda1af9d0a1f64cc028df7556705d98471fdf3d0830282d4dcfb7a78cc"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"

    resource("Mako").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    resource("gears.c").stage(pkgshare.to_s)

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-D buildtype=plain", "-D b_ndebug=true", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system ENV.cc, "#{pkgshare}/gears.c", "-o", "gears", "-L#{lib}", "-I#{Formula["freeglut"].opt_include}", "-L#{Formula["freeglut"].opt_lib}", "-lgl", "-lglut"
  end
end
