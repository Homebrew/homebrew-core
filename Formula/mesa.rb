class Mesa < Formula
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-20.1.4.tar.xz"
  sha256 "6800271c2be2a0447510eb4e9b67edd9521859a4d565310617c4b359eb6799fe"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  bottle do
    cellar :any
    sha256 "0ca7669cebc82d5b59c9a41d1f9b5ebc9e07215e9297b7f7bad32f92182e920e" => :catalina
    sha256 "2e70646a569df862685e6daabb723a83dae64b59d0ee2e26441c70f69948fdc5" => :mojave
    sha256 "6827b0ade68f0cffc757741b9a9c735a76a357fe42a1231510d9bf6f284fe12d" => :high_sierra
  end

  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "freeglut" => :test
  depends_on "expat"
  depends_on "gettext"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/72/89/402d2b4589e120ca76a6aed8fee906a0f5ae204b50e455edd36eda6e778d/Mako-1.1.3.tar.gz"
    sha256 "8195c8c1400ceb53496064314c6736719c6f25e7479cd24c77be3d9361cddc27"
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
      system "meson", *std_meson_args, "..", "-Db_ndebug=true",
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
