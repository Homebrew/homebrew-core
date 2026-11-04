class Mrgingham < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Chessboard corner finder for camera calibration"
  homepage "https://github.com/dkogan/mrgingham"
  url "https://github.com/dkogan/mrgingham/archive/refs/tags/v1.29.tar.gz"
  sha256 "f20d48c001abec4f667f785f587059d2097a20fb50a995d923cb96c1c8b0f508"
  license all_of: ["LGPL-2.1-or-later", "MIT"]
  compatibility_version 1

  # Only release tags: the repo also has pre-release, wheel/, debian/,
  # mrbuild_ and dated tags, and the dated ones sort as newer.
  livecheck do
    url "https://github.com/dkogan/mrgingham.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "mrbuild" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python-packaging"
  depends_on "python@3.15"
  depends_on "vnlog"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gnu-getopt"
  end

  # Not on PyPI itself: only its Python dependencies are resources
  pypi_packages package_name:     "",
                extra_packages:   %w[numpysane gnuplotlib],
                exclude_packages: %w[numpy packaging]

  resource "numpysane" do
    url "https://files.pythonhosted.org/packages/16/3e/9ff84572ceb48c1c5ce08000192d13c2f904a650fb34a876e3f7f83acf79/numpysane-0.45.tar.gz"
    sha256 "caebeccc2c92d373ee3d850f45d7724cab1067e912efe8a8fa54167f5d1b4a82"
  end

  resource "gnuplotlib" do
    url "https://files.pythonhosted.org/packages/88/81/24068edcc7b383d776dedc7509aec1352abd6746c3448b3761668cb56738/gnuplotlib-0.47.tar.gz"
    sha256 "35ad06a4adf16dba0e4be0f74615e7beb6b8e0358c4cf5c0f98fef85bc46aac8"
  end

  def python3
    "python3.15"
  end

  def install
    # mrgingham-observe-pixel-uncertainty and the tests need numpysane and
    # gnuplotlib. The venv sees numpy, vnlog and packaging in Homebrew's
    # site-packages.
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources, build_isolation: false
    rewrite_shebang python_shebang_rewrite_info(libexec/"bin/python"), "mrgingham-observe-pixel-uncertainty"

    # Each project's choose_mrbuild.mk uses ./mrbuild if it exists
    mrbuild = formula_opt_include("mrbuild")/"mrbuild"
    (buildpath/"mrbuild").install_symlink mrbuild.children
    (buildpath/"mrbuild").install_symlink formula_opt_bin("mrbuild") => "bin"

    # mrgingham-rotate-corners parses its options with GNU getopt; macOS's has no long options
    if OS.mac?
      inreplace "mrgingham-rotate-corners", "$(getopt ", "$(#{formula_opt_bin("gnu-getopt")}/getopt "
    end

    site_packages = Language::Python.site_packages(python3)
    args = %W[
      VERSION=#{version}
      USE_DEBIAN_PATHS=
      PYTHON_VERSION_FOR_EXTENSIONS=#{python3.delete_prefix("python")}
      DESTDIR=#{prefix}
      INSTALL_ROOT_LIB=/lib
      INSTALL_ROOT_BIN=/bin
      INSTALL_ROOT_INCLUDE=/include/mrgingham
      INSTALL_ROOT_MAN=/share/man
      INSTALL_ROOT_PY3_MODULES=/#{site_packages}
    ]
    # opencv5.pc lists every OpenCV module; link only the ones in use
    ENV.append "LDFLAGS", OS.mac? ? "-Wl,-dead_strip_dylibs" : "-Wl,--as-needed"

    system "make", *args
    system libexec/"bin/python", "test/test--mrgingham-find-board"
    system "make", "install", *args

    # On macOS, mrbuild deletes the @loader_path rpaths it linked with, and
    # its Python extension never gets LDFLAGS. Point both at lib.
    if OS.mac?
      ext = Dir[prefix/site_packages/"mrgingham*.so"].first
      [bin/"mrgingham", Pathname(ext)].each do |f|
        MachO::Tools.add_rpath(f.to_s, rpath(source: f.dirname), strict: false)
        MachO.codesign!(f) if Hardware::CPU.arm?
      end
    end
  end

  test do
    (testpath/"board.py").write <<~PY
      import numpy as np

      # A 10x10-corner chessboard with 50-pixel squares, slightly blurred
      n, square, margin = 11, 50, 80
      image = np.full((n*square + 2*margin,) * 2, 255.)
      for i in range(n):
          for j in range(n):
              if (i + j) % 2 == 0:
                  image[margin + i*square: margin + (i+1)*square,
                        margin + j*square: margin + (j+1)*square] = 0
      k = np.array((1., 4., 6., 4., 1.)) / 16.
      for axis in (0, 1):
          image = np.apply_along_axis(lambda r: np.convolve(r, k, 'same'), axis, image)
      image = image.astype(np.uint8)

      with open("board.pgm", "wb") as f:
          f.write(b"P5 %d %d 255\\n" % (image.shape[1], image.shape[0]))
          f.write(image.tobytes())

      import mrgingham
      corners = mrgingham.find_board(image, gridn=10)
      assert corners.shape == (100, 2), corners
    PY
    system python3, "board.py"

    output = shell_output("#{bin}/mrgingham board.pgm")
    assert_equal 100, output.lines.count { |l| l.start_with?("board.pgm ") }

    output = shell_output("#{bin}/mrgingham-observe-pixel-uncertainty --help")
    assert_match "observed point distribution", output
  end
end
