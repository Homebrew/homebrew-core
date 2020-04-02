class Mesa < Formula
  include Language::Python::Virtualenv
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-20.0.4.tar.xz"
  mirror "https://www.mesa3d.org/archive/mesa-20.0.4.tar.xz"
  sha256 "c4ed491517a94118a7a611810eeb92645d42ffd82280dcd51be8cc2ba1aabba5"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  bottle do
    cellar :any
    sha256 "ac53539ca15ff7424684d66c60cd936087fd09fe22581fcb291c75e5fc8de16a" => :catalina
    sha256 "2ec403b7dc05931f1a6494b88a8b5a96e67c531ffd13afaea203d34e4880e763" => :mojave
    sha256 "5add0b795f62ee9425d7eebe04ad6889589b3d947d5d3f9f911524321ff445cf" => :high_sierra
  end

  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "freeglut" => :test
  depends_on "expat"
  depends_on "gettext"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/42/64/fc7c506d14d8b6ed363e7798ffec2dfe4ba21e14dda4cfab99f4430cba3a/Mako-1.1.2.tar.gz"
    sha256 "3139c5d64aa5d175dbafb95027057128b5fbd05a40c53999f3905ceb53366d9d"
  end

  resource "gears.c" do
    url "https://www.opengl.org/archives/resources/code/samples/glut_examples/mesademos/gears.c"
    sha256 "7df9d8cda1af9d0a1f64cc028df7556705d98471fdf3d0830282d4dcfb7a78cc"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    resource("Mako").stage do
      system "python3", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    resource("gears.c").stage(pkgshare.to_s)

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "..", "-Dbuildtype=plain", "-Db_ndebug=true",
                      "-Dplatforms=surfaceless", "-Dglx=disabled"
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    flags = %W[
      -framework OpenGL
      -I#{Formula["freeglut"].opt_include}
      -L#{Formula["freeglut"].opt_lib}
      -lglut
    ]
    system ENV.cc, "#{pkgshare}/gears.c", "-o", "gears", *flags
  end
end
