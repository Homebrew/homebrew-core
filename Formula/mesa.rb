class Mesa < Formula
  include Language::Python::Virtualenv
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-19.0.2.tar.xz"
  sha256 "1a2edc3ce56906a676c91e6851298db45903df1f5cb9827395a922c1452db802"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  bottle do
    sha256 "f49688c8eaedb386ba6eff566aff88444f715b26c02477b27a0837997abb04a9" => :mojave
    sha256 "84f4755232903b4bf8fe44345a36f2ea151f082cfe568bac893e59c33a3c589c" => :high_sierra
    sha256 "c66a69892dca57ff8f78c58930609f14c65f06f8e5a47e8fa36adbf373c3fbc8" => :sierra
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
    url "https://files.pythonhosted.org/packages/eb/f3/67579bb486517c0d49547f9697e36582cd19dafb5df9e687ed8e22de57fa/Mako-1.0.7.tar.gz"
    sha256 "4e02fde57bd4abb5ec400181e4c314f56ac3e49ba4fb8b0d50bba18cb27d25ae"
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
