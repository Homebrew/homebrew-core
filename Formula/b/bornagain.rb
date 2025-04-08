class Bornagain < Formula
  include Language::Python::Virtualenv

  desc "Simulate and fit neutron and x-ray reflectometry and GISAS"
  homepage "https://bornagainproject.org"

  url "https://jugit.fz-juelich.de/mlz/bornagain.git",
      tag: "v22.0", revision: "08e72eb7da6677fde2178a7b879686c469fb90b5", depth: 1

  license "GPL-3.0-or-later"

  depends_on :macos

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gsl"
  depends_on "libcerf"
  depends_on "libformfactor"
  depends_on "libheinz"
  depends_on "libtiff"
  depends_on "python"
  depends_on "qt"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/e1/78/31103410a57bc2c2b93a3597340a8119588571f6a4539067546cb9a0bfac/numpy-2.2.4.tar.gz"
    sha256 "9ba03692a45d3eef66559efe1d1096c4b9b75c0986b5dff5530c378fb8331d4f"
  end

  resource "matplotlib" do
    url "https://files.pythonhosted.org/packages/2f/08/b89867ecea2e305f408fbb417139a8dd941ecf7b23a2e02157c36da546f0/matplotlib-3.10.1.tar.gz"
    sha256 "e8d2d0e3881b129268585bf4765ad3ee73a4591d77b9a18c214ac7e3a79fb2ba"
  end

  resource "fabio" do
    url "https://files.pythonhosted.org/packages/ac/47/cd067e985b8a2476024b64373538c7e2b65b53415b39229e253d168d6d78/fabio-2024.9.0.tar.gz"
    sha256 "f873df51f468531c11aae7e0cd88a14f221f4ef09431fbc5a6ca67b1ed47535b"
  end

  def make_shims(venv_py)
    # produce helper scripts

    brew_bin_pth = (HOMEBREW_PREFIX/"bin/").realpath

    # extract the installation location of the BornAgain package via `pip show`
    # eg. 'Location: /opt/homebrew/Cellar/bornagain/22.0/venv/lib/python3.12/site-packages'
    location_rx = /^\s*Location\s*:\s*(.+)\s*/i
    info = `#{venv_py} -m pip show bornagain`
    ba_loc = info.match(location_rx)[1]

    shim = prefix/"shim"
    mkdir_p shim

    # script to run BornAgain GUI with embedded Python
    gui_script = %Q(\
     #! /bin/sh

     # run BornAgain with Python support
     export PYTHONPATH="#{ba_loc}:${PYTHONPATH}"

     #{bin}/bornagain
    )

    ba_gui_cmd = shim/"bornagain_gui"
    File.write(ba_gui_cmd, gui_script, mode: "w")
    # make the script executable for all users
    chmod 0755, ba_gui_cmd

    # script to use BornAgain Python package
    pyenv_script = %Q(\
     #! /bin/sh

     # add BornAgain package path to PYTHONPATH
     export PYTHONPATH="#{ba_loc}:${PYTHONPATH}"

     # usage:
     # $ source #{brew_bin_pth}/bornagain_py"
    )

    ba_pyenv_cmd = shim/"bornagain_py"
    f = File.write(ba_pyenv_cmd, pyenv_script, mode: "w")
    chmod 0755, ba_pyenv_cmd

    # script to display info about BornAgain
    ba_share = share/"BornAgain"

    info_script = %Q(\
     #! /bin/sh

     echo '-------------- BornAgain ---------------'
     echo '* BornAgain: simulate and fit reflection and scattering'
     echo '* Homepage: <http://www.bornagainproject.org>'
     echo '* Copyright Forschungszentrum Jülich GmbH 2018'
     echo '----------------------------------------'
     echo '* Version #{version}: #{prefix}/'
     echo '* Python wheel: #{ba_share}/wheel/'
     echo '* Python examples: #{ba_share}/Examples/'
     echo '* Build log: #{ba_share}/bornagain_build.log'
     echo '----------------------------------------'
     echo '* Run GUI with Python support:'
     echo '$ bornagain'
     echo '----------------------------------------'
     echo "* Use BornAgain as a Python package:"
     echo '$ source #{brew_bin_pth}/bornagain_py'
     echo '----------------------------------------'
    )

    ba_info_cmd = shim/"bornagain_info"
    File.write(ba_info_cmd, info_script, mode: "w")
    chmod 0755, ba_info_cmd
  end

  def install
    ff_cmake_dir = Formula["libformfactor"].prefix/"cmake/"
    heinz_cmake_dir = Formula["libheinz"].prefix/"cmake/"

    # Build a Python virtual environment with the required packages
    venv = virtualenv_create(prefix/"venv", "python3")
    venv_root = venv.instance_variable_get(:@venv_root)
    venv_py = venv_root/"bin/python3"
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build",
           *std_cmake_args, "-DBA_TESTS=OFF",
           "-DBORNAGAIN_PYTHON=ON",
           "-DBA_PY_PACK=ON",
           "-DCMAKE_PREFIX_PATH=#{ff_cmake_dir};#{heinz_cmake_dir};",
           "-DPython3_EXECUTABLE=#{venv_py}"

    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "ba_wheel"
    system "cmake", "--install", "build"

    # Install the BornAgain Python wheel in the virtual environment
    ba_wheel = Dir.glob("build/py/wheel/*.whl").first
    system venv_py, "-m", "pip", "install", ba_wheel

    make_shims(venv_py)
  end

  def post_install
    brew_bin_pth = (HOMEBREW_PREFIX/"bin/").realpath
    shim = prefix/"shim"

    # GUI entrypoint
    brew_bin_pth.install_symlink shim/"bornagain_gui" => "bornagain"

    # BornAgain Python environment
    brew_bin_pth.install_symlink shim/"bornagain_py" => "bornagain_py"

    # BornAgain info
    brew_bin_pth.install_symlink shim/"bornagain_info" => "bornagain_info"
  end

  test do
    test_script = %Q(\
     #! /bin/sh

     # test BornAgain wheel
     source "#{HOMEBREW_PREFIX}/bin/bornagain_py"
     python3 "#{share}/BornAgain/Examples/fit/scatter2d/fit2d.py"
    )

    ba_test_cmd = testpath/"test_bornagain.sh"
    File.write(ba_test_cmd, test_script, mode: "w")

    system "/bin/sh", ba_test_cmd
  end
end
