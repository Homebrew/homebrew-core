class Bornagain < Formula
  require "etc"

  desc "Simulate and fit neutron and x-ray reflectometry and GISAS"
  homepage "https://bornagainproject.org"

  url "https://jugit.fz-juelich.de/mlz/bornagain.git",
      tag: "v22.0", revision: "08e72eb7da6677fde2178a7b879686c469fb90b5", depth: 1

  license "GPL-3.0-or-later"

  depends_on "cmake" => [:build, "3.20"]
  depends_on "fftw"
  depends_on "gsl"
  depends_on "libcerf"
  depends_on "libformfactor" => "0.3.2"
  depends_on "libheinz" => "2.0.1"
  depends_on "libtiff"
  depends_on "python@3"
  depends_on "qt@6"

  def build_dir
    "#{buildpath}/build/"
  end

  def local_dir
    "#{build_dir}/var/local/"
  end

  def nproc
    [Etc.nprocessors - 2, 1].max
  end

  def cmake_exe
    "#{Formula["cmake"].opt_bin.realpath}/cmake"
  end

  def ctest_exe
    "#{Formula["cmake"].opt_bin.realpath}/ctest"
  end

  def python3_exe
    # default Python
    "python3"
  end

  def qt_cmake_dir
    Formula["qt@6"].prefix/"lib/cmake/"
  end

  def ff_cmake_dir
    Formula["libformfactor"].prefix/"cmake/"
  end

  def heinz_cmake_dir
    Formula["libheinz"].prefix/"cmake/"
  end

  def create_venv(root, prompt = "")
    puts ".: Creating a Python virtualenv in '#{root}'..."

    if prompt.empty?
      system python3_exe, "-m", "venv", "--clear", root
    else
      system python3_exe, "-m", "venv", "--clear", "--prompt", prompt, root
    end

    "#{root}/bin/python3"
  end

  def install
    odie ".: Error: This BornAgain install script is intended for MacOS only." unless OS.mac?

    if Hardware::CPU.arm?
      puts ".: ARM architecture detected."
    elsif Hardware::CPU.intel?
      puts ".: Intel architecture detected."
    else
      odie ".: Error: Hardware architecture is not supported."
    end

    if Hardware::CPU.is_64_bit?
      puts ".: 64-bit architecture detected."
    else
      odie ".: Error: Hardware architecture is not supported."
    end

    cmake = Formula["cmake"]
    cmake_dir = cmake.prefix.realpath
    cmake_ver = cmake.version
    # path of the Python executable
    py_dir = `#{python3_exe} -c "import sys; print(sys.executable)"`.strip
    # major and minor version of the Python platform
    py_ver = `#{python3_exe} --version`.split[1]
    py_v = py_ver.split(".")
    py_v_major = py_v[0].to_i
    py_v_minor = py_v[1].to_i

    puts ".: CMake #{cmake_ver} at '#{cmake_dir}'"
    puts ".: Python #{py_ver} at '#{py_dir}'"
    puts ".: BornAgain #{version} build directory: '#{build_dir}'"
    puts ".: BornAgain installation prefix: '#{prefix}'"
    puts ".: std_cmake_args = ", std_cmake_args.inspect

    odie ".: Error: BornAgain requires Python 3.10 or later." if py_v_major < 3 || py_v_minor < 10

    # Python virtual environment
    venv_root = "#{local_dir}/venv"
    venv_py = create_venv(venv_root)

    puts "   - Installing the required packages in the Python virtualenv..."
    system venv_py, "-m", "pip", "install", "numpy>=2.0.0", "setuptools", "wheel"

    py_pkgs = ["numpy", "setuptools", "wheel"]
    py_pkg_info = {}
    name_rx = /^\s*Name\s*:\s*([\w_]+)/i        # eg. 'Name: numpy'
    version_rx = /^\s*Version\s*:\s*([\d.]+)/i  # eg., 'Version: 1.2.3'

    py_pkgs.each do |pkg|
      # extract package info via `pip show`
      info = `#{venv_py} -m pip show #{pkg}`
      nm = info.match(name_rx)[1]
      ver = info.match(version_rx)[1]
      py_pkg_info[nm] = ver
    end

    puts ".: Python virtualenv:"
    py_pkg_info.each do |nm, ver|
      puts "   #{nm} : #{ver}"
    end

    puts ".: Building BornAgain..."

    ba_cmd = [cmake_exe, "-S", buildpath.to_s, "-B", build_dir.to_s,
              *std_cmake_args, "-DBA_TESTS=OFF",
              "-DCMAKE_PREFIX_PATH=#{qt_cmake_dir};#{ff_cmake_dir};#{heinz_cmake_dir};",
              "-DBORNAGAIN_PYTHON=ON", "-DBA_PY_PACK=ON",
              "-DPython3_EXECUTABLE=#{venv_py}"]

    puts "   >> " + ba_cmd.join(" ")

    # CMake configuration step
    system(*ba_cmd)

    # CMake build step
    system cmake_exe, "--build", build_dir.to_s,
           "--config", "Release", "--parallel", nproc

    puts "   - Building BornAgain Python wheel..."
    system cmake_exe, "--build", build_dir.to_s,
           "--config", "Release", "--target", "ba_wheel"

    puts ".: Building BornAgain: Done."

    # CMake install step
    puts ".: Installing BornAgain..."
    system cmake_exe, "--install", build_dir.to_s, "--config", "Release"
    puts ".: Installing BornAgain: Done."
  end

  def post_install
    # install the BornAgain Python wheel in a dedicated virtual environment
    puts ".: Building BornAgain virtual environment..."
    venv_root = (Pathname "#{prefix}/").realpath/"venv"
    venv_py = create_venv(venv_root, "BornAgain")

    wheelname = Dir.glob("#{share}/BornAgain/wheel/*.whl").first
    puts ".: Installing BornAgain wheel '#{wheelname}'..."
    system venv_py, "-m", "pip", "install", wheelname
    # install Fabio package
    system venv_py, "-m", "pip", "install", "fabio"

    # extract the installation location of the BornAgain package via `pip show`
    # eg. 'Location: /opt/homebrew/Cellar/bornagain/22.0/venv/lib/python3.12/site-packages'
    location_rx = /^\s*Location\s*:\s*(.+)\s*/i
    info = `#{venv_py} -m pip show bornagain`
    ba_loc = info.match(location_rx)[1]

    # script to run BornAgain GUI with embedded Python
    gui_script = %Q(\
     #! /bin/sh

     # run BornAgain with Python support
     source #{venv_root}/bin/activate
     export PYTHONPATH="#{ba_loc}:${PYTHONPATH}"
     #{bin}/bornagain
    )

    ba_gui_cmd = "#{bin}/bornagain_gui.sh"
    File.write(ba_gui_cmd, gui_script, mode: "w")
    # make the script executable for all users
    chmod 0755, ba_gui_cmd

    # GUI entrypoint (symlink)
    brew_bin_pth = (Pathname "#{HOMEBREW_PREFIX}/bin/").realpath
    brew_bin_pth.install_symlink ba_gui_cmd => "bornagain"

    # script to activate BornAgain's Python virtual environment
    pyenv_script = %Q(\
     #! /bin/sh

     # activate BornAgain's Python virtual environment
     source #{venv_root}/bin/activate
     export PYTHONPATH="#{ba_loc}:${PYTHONPATH}"

     # usage:
     # $ source #{brew_bin_pth}/bornagain_py"
    )

    ba_pyenv_cmd = "#{bin}/bornagain_py.sh"

    File.write(ba_pyenv_cmd, pyenv_script, mode: "w")
    chmod 0755, ba_pyenv_cmd
    brew_bin_pth.install_symlink ba_pyenv_cmd => "bornagain_py"

    puts ".: Building BornAgain virtual environment: Done."

    # script to display info about BornAgain
    ba_share = "#{share}/BornAgain"
    info_script = %Q(\
     #! /bin/sh

     echo '-------------- BornAgain ---------------'
     echo '* BornAgain #{version}: #{prefix}/'
     echo '* Python wheel: #{ba_share}/wheel/'
     echo '* Python examples: #{ba_share}/Examples/'
     echo '* Build log: #{ba_share}/bornagain_build.log'
     echo '----------------------------------------'
     echo '* Run GUI with Python support:'
     echo '$ bornagain'
     echo '----------------------------------------'
     echo "* Activate BornAgain's Python virtual environment"
     echo "  where BornAgain wheel is already installed:"
     echo '$ source #{brew_bin_pth}/bornagain_py'
     echo '----------------------------------------'
    )

    ba_info_cmd = "#{bin}/bornagain_info.sh"
    File.write(ba_info_cmd, info_script, mode: "w")
    chmod 0755, ba_info_cmd
    brew_bin_pth.install_symlink ba_info_cmd => "bornagain_info"

    puts ".: To obtain info about BornAgain, use the shell command:"
    puts "   $ bornagain_info"
  end

  test do
    puts ".: Testing BornAgain..."
    test_script = %Q(\
     #! /bin/sh

     # test BornAgain wheel
     source "#{HOMEBREW_PREFIX}/bin/bornagain_py"
     #{python3_exe} "#{share}/BornAgain/Examples/fit/scatter2d/fit2d.py"
    )

    ba_test_cmd = "#{testpath}/test_bornagain.sh"
    File.write(ba_test_cmd, test_script, mode: "w")

    system "/bin/sh", ba_test_cmd
    puts ".: Testing BornAgain: Done."
  end
end
