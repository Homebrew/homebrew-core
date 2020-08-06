class Mesa < Formula
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-20.1.5.tar.xz"
  sha256 "fac1861e6e0bf1aec893f8d86dbfb9d8a0f426ff06b05256df10e3ad7e02c69b"
  head "https://gitlab.freedesktop.org/mesa/mesa.git"

  bottle do
    cellar :any
    sha256 "de2b15c1f403ad2ac5f387e5a28f175bced8685bf1156beaf5d726d9ae979756" => :catalina
    sha256 "2b2c1cce0ee6c9bc5619165ad869c4321848b7a7ffa6e42c802e1b68938b86af" => :mojave
    sha256 "8f9fbb495c5e259ea787cdded1d51d8816773974d52adedbe4b04e847ecbb3cb" => :high_sierra
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
