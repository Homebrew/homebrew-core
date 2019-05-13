class Mesa < Formula
  include Language::Python::Virtualenv
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-19.0.4.tar.xz"
  sha256 "39f9f32f448d77388ef817c6098d50eb0c1595815ce7e895dec09dd68774ce47"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  bottle do
    sha256 "272c6fccac8c4f857cfefcd069f6d81ff36a75ecfceab8b799c3ff3846b9b8cc" => :mojave
    sha256 "d89a8d65517d69c69aa489b7d1d1e39e9f6103fc73d74cbd32c924e7db342a81" => :high_sierra
    sha256 "eb505185523aaa863675775b75ef1b4207a04369190c4bda0efe4e781eae4116" => :sierra
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
