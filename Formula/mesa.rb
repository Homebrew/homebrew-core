class Mesa < Formula
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-20.0.7.tar.xz"
  mirror "https://www.mesa3d.org/archive/mesa-20.0.7.tar.xz"
  sha256 "fe6e258fe772c3cd2ac01741bf7408058c3ac02d66acff9a6e669bd72e3ea178"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  bottle do
    cellar :any
    sha256 "5e98f4fba62e64508af92a79632c24927b03893a8df2d95a47a46ed2e8f93fba" => :catalina
    sha256 "6bf76a7dbf8961ac8ebd910cc776b0ecf75a54b16728f2ae6362e95fb72d6215" => :mojave
    sha256 "7d72059dda9e4d6b2f9166b8edee0e9696283f1377d114baff9200a6977622f1" => :high_sierra
  end

  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
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
    python3 = Formula["python@3.8"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    resource("Mako").stage do
      system python3, *Language::Python.setup_install_args(buildpath/"vendor")
    end

    resource("gears.c").stage(pkgshare.to_s)

    mkdir "build" do
      system "meson", *std_meson_args, "..", "-Dbuildtype=plain", "-Db_ndebug=true",
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
