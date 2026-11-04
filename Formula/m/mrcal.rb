class Mrcal < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Camera calibration and stereo toolkit"
  homepage "https://mrcal.secretsauce.net"
  url "https://github.com/dkogan/mrcal/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "aae6e816fdf851c4241058d0c8a3b8e867ac8492a54887da18d38a46702f1672"
  license "Apache-2.0"

  # Only release tags: the repo also has pre-release, wheel/, debian/,
  # mrbuild_ and dated tags, and the dated ones sort as newer.
  livecheck do
    url "https://github.com/dkogan/mrcal.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cython" => :build
  depends_on "meson" => :build
  depends_on "mrbuild" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "re2c" => :build
  depends_on "geos"
  depends_on "gnuplot"
  depends_on "jpeg-turbo"
  depends_on "libdogleg"
  depends_on "libpng"
  depends_on "libyaml"
  depends_on "mrgingham"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "opencv"
  depends_on "python-packaging"
  depends_on "python@3.15"
  depends_on "scipy"
  depends_on "suite-sparse"
  depends_on "vnlog"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "zsh" => :build # test.sh
  end

  # Resolve only the dependencies: mrcal's own Python package builds with
  # make. meson-python and pyproject-metadata only build shapely.
  pypi_packages package_name:     "",
                extra_packages:   %w[numpysane gnuplotlib pyyaml shapely meson-python pyproject-metadata],
                exclude_packages: %w[numpy packaging meson]

  resource "stb" do
    url "https://github.com/nothings/stb/archive/2c980bb59875b0d32144a71867fbdebb2f77cd20.tar.gz"
    version "2026-08-02"
    sha256 "9a955b1b49a4410088a2e0ee2a9c057c3c907d0c1d75454144cb980aca0ba515"
  end

  resource "numpysane" do
    url "https://files.pythonhosted.org/packages/16/3e/9ff84572ceb48c1c5ce08000192d13c2f904a650fb34a876e3f7f83acf79/numpysane-0.45.tar.gz"
    sha256 "caebeccc2c92d373ee3d850f45d7724cab1067e912efe8a8fa54167f5d1b4a82"
  end

  resource "gnuplotlib" do
    url "https://files.pythonhosted.org/packages/88/81/24068edcc7b383d776dedc7509aec1352abd6746c3448b3761668cb56738/gnuplotlib-0.47.tar.gz"
    sha256 "35ad06a4adf16dba0e4be0f74615e7beb6b8e0358c4cf5c0f98fef85bc46aac8"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/f3/ab/924b6e202f796d270a3041a230151f7908db5ea48c74effe6f8023e9bd05/shapely-2.2.0.tar.gz"
    sha256 "e8865e553d874a1ec4a032057ea81fca9def37b188cd8fb550af3b3480b3f88c"
  end

  # Only to build shapely
  resource "meson-python" do
    url "https://files.pythonhosted.org/packages/b4/40/343ae23722d5d66a7b94b752d1b194202640995296379333b274b1860871/meson_python-0.22.1.tar.gz"
    sha256 "52c88628b0e5671592dc2306613fb5f6f3615fd24def059b9894f143b7f9a139"
  end

  resource "pyproject-metadata" do
    url "https://files.pythonhosted.org/packages/4f/76/1cae539918a7b1746d624c2f01560b793c22cd8c081157505bb9bbf0e34d/pyproject_metadata-0.12.1.tar.gz"
    sha256 "8809a4df6fe08279b39a8890669506ed3158e0617855ac9aff098fcbe772ae4c"
  end

  def python3
    "python3.15"
  end

  def install
    site_packages = Language::Python.site_packages(python3)

    # The Python packages that aren't in Homebrew go in a venv, which also
    # sees numpy, scipy, cv2 and packaging in Homebrew's site-packages. The
    # mrcal package itself goes in python3.15's site-packages, and a .pth file
    # each way lets "import mrcal" work from either.
    venv = virtualenv_create(libexec, python3)
    venv.pip_install %w[numpysane gnuplotlib].map { |r| resource(r) }, build_isolation: false

    # shapely builds with meson-python, which isn't in Homebrew. It and
    # pyproject-metadata are pure Python, so putting their sources on the
    # PYTHONPATH is enough. Homebrew's Cython lives in its libexec; pyyaml
    # needs it to build its libyaml extension.
    build_pythonpath = %w[meson-python pyproject-metadata].map do |r|
      (buildpath/r).install resource(r)
      buildpath/r
    end
    build_pythonpath << (formula_opt_libexec("cython")/site_packages)
    with_env(PYTHONPATH: build_pythonpath.join(":")) do
      venv.pip_install %w[pyyaml shapely].map { |r| resource(r) }, build_isolation: false
    end
    (libexec/site_packages/"homebrew-mrcal.pth").write "#{opt_prefix/site_packages}\n"

    # Each project's choose_mrbuild.mk uses ./mrbuild if it exists
    mrbuild = formula_opt_include("mrbuild")/"mrbuild"
    (buildpath/"mrbuild").install_symlink mrbuild.children
    (buildpath/"mrbuild").install_symlink formula_opt_bin("mrbuild") => "bin"

    (buildpath/"stb/stb").install resource("stb").files("stb_image.h")
    ENV.append "CFLAGS", "-I#{buildpath}/stb"

    # The *-genpywrap.py generators run "python3", and need numpysane
    ENV.prepend_path "PATH", libexec/"bin"

    args = %W[
      VERSION=#{version}
      USE_LOCAL_STB_IMPLEMENTATION=1
      USE_DEBIAN_PATHS=
      PYTHON_VERSION_FOR_EXTENSIONS=#{python3.delete_prefix("python")}
      DESTDIR=#{prefix}
      INSTALL_ROOT_LIB=/lib
      INSTALL_ROOT_BIN=/bin
      INSTALL_ROOT_INCLUDE=/include/mrcal
      INSTALL_ROOT_MAN=/share/man
      INSTALL_ROOT_PY3_MODULES=/#{site_packages}
    ]

    system "make", *args
    # The quick test set takes about a minute
    system "make", "test-nosampling", *args
    system "make", "install", *args

    rewrite_shebang python_shebang_rewrite_info(libexec/"bin/python"), *bin.children
    (prefix/site_packages/"homebrew-mrcal-deps.pth").write "#{opt_libexec/site_packages}\n"

    # On macOS, mrbuild deletes the @loader_path rpaths it linked with. Point
    # the extension modules at lib.
    if OS.mac?
      (prefix/site_packages/"mrcal").glob("*.so").each do |f|
        MachO::Tools.add_rpath(f.to_s, rpath(source: f.dirname), strict: false)
        MachO.codesign!(f) if Hardware::CPU.arm?
      end
    end
  end

  test do
    # Project a point through an opencv8 model, and back
    system python3, "-c", <<~PY
      import numpy as np
      import mrcal
      m = mrcal.cameramodel(intrinsics = ("LENSMODEL_OPENCV8",
                                          np.array((1000., 1000., 500., 400.,
                                                    0.1, -0.05, 0.001, 0.002, 0., 0., 0., 0.))),
                            imagersize = (1000, 800))
      m.write("cam.cameramodel")
      p = np.array((0.1, -0.2, 1.0))
      q = mrcal.project(p, *m.intrinsics())
      v = mrcal.unproject(q, *m.intrinsics(), normalize = True)
      assert np.allclose(v, p / np.linalg.norm(p)), v
    PY

    output = shell_output("#{bin}/mrcal-convert-lensmodel --help")
    assert_match "Converts a camera model", output
    output = pipe_output("#{bin}/mrcal-to-cahvor -", (testpath/"cam.cameramodel").read, 0)
    assert_match(/^C\s*=/, output)

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <mrcal/mrcal.h>
      int main(void)
      {
        mrcal_lensmodel_t m = {.type = MRCAL_LENSMODEL_OPENCV8};
        printf("%d\\n", mrcal_lensmodel_num_params(&m));
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmrcal", "-o", "test"
    assert_equal "12", shell_output("./test").strip
  end
end
