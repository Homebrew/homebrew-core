class LpSolve < Formula
  desc "Mixed Integer Linear Programming (MILP) solver"
  homepage "https://sourceforge.net/projects/lpsolve/"
  url "https://downloads.sourceforge.net/lpsolve/lp_solve_5.5.2.5_source.tar.gz"
  version "5.5.2.5" # automatic version parser spits out "solve" as version
  sha256 "201a7c62b8b3360c884ee2a73ed7667e5716fc1e809755053b398c2f5b0cf28a"

  depends_on "numpy"
  depends_on "python@2"
  depends_on :java => :optional

  resource "lp_solve_python" do
    # 'http://lpsolve.sourceforge.net/5.5/Python.htm'
    url "https://downloads.sourceforge.net/lpsolve/lp_solve_5.5.2.5_Python_source.tar.gz"
    sha256 "ceb10b18bd169afaaac5f88072f406cd7539fb07cdf5de5b83f599f94159513b"
    version "5.5.2.5"
  end

  resource "lp_solve_java" do
    # http://lpsolve.sourceforge.net/5.5/Java.htm
    url "https://downloads.sourceforge.net/lpsolve/lp_solve_5.5.2.5_java.zip"
    sha256 "0a4dcd21e0c494f51b5de4e5e7bcd608c71bbab957e37ac776cba19808a2d6c9"
    version "5.5.2.5"
  end

  def install
    # Thanks to superenv, we don't have to care if the ccc.osx build script
    # tells the compiler stupid things. And Xcode-only works like charm.

    # Clang on :snow_leopard does not ignore `-Wno-long-double` and errors out.
    if MacOS.version <= :snow_leopard
      files = %w[configure configure.ac demo/ccc.osx
                 lp_solve/ccc.osx lpsolve55/ccc.osx lpsolve55/cccLUSOL.osx]
      files.each { |f| inreplace f, "-Wno-long-double", "" }
    end

    cd "lpsolve55" do
      system "sh", "ccc.osx", "#", "lpsolve55", "library"
      lib.install Dir["./bin/osx64/*.a"]
      lib.install Dir["./bin/osx64/*.dylib"]
    end

    cd "lp_solve" do
      system "sh", "ccc.osx", "#", "lp_solve", "executable"
      bin.install "./bin/osx64/lp_solve"
    end

    include.install Dir["*.h"]
    include.install "shared/commonlib.h", "shared/myblas.h"
    include.install Dir["bfp/bfp_LUSOL/LUSOL/lusol*.h"]

    install_python_bindings
    install_java_bindings if build.with? :java
  end

  def install_python_bindings
    # In order to install into the Cellar, the dir must exist and be in the
    # PYTHONPATH.
    temp_site_packages = lib/which_python/"site-packages"
    mkdir_p temp_site_packages
    ENV["PYTHONPATH"] = temp_site_packages
    args = [
      "--force",
      "--verbose",
      "--install-scripts=#{share}/python",
      "--install-lib=#{temp_site_packages}",
      "--record=installed-files.txt",
    ]

    resource("lp_solve_python").stage do
      cd "extra/Python" do
        # On OS X malloc there is <sys/malloc.h> and <malloc/malloc.h>
        inreplace "hash.c", "#include <malloc.h>", "#include <sys/malloc.h>"
        # We know where the lpsolve55 lib is...
        inreplace "setup.py", "LPSOLVE55 = '../../lpsolve55/bin/ux32'", "LPSOLVE55 = '#{lib}'"
        # Correct path to lpsolve's include dir and go the official way to find numpy include_dirs
        inreplace "setup.py",
                  "include_dirs=['../..', NUMPYPATH],",
                  "include_dirs=['#{include}', '#{numpy_include_dir}'],"
        inreplace "setup.py", "(NUMPY, '1')", "('NUMPY', '1')"
        # Even their version number is broken ...
        inreplace "setup.py", 'version = "5.5.0.10",', "version = '#{version}',"

        system "python", "setup.py", "--no-user-cfg", "install", *args

        # Save the examples
        pkgshare.install Dir["ex*.py"], "lpdemo.py", "Python.htm"
      end
    end
  end

  def install_java_bindings
    resource("lp_solve_java").stage(buildpath/"java")
    cd "#{buildpath}/java/lib/mac" do
      inreplace "build-osx" do |s|
        s.gsub! /^LPSOLVE_DIR=.*$/, "LPSOLVE_DIR=#{include}"
        s.gsub! /liblpsolve55j\.jnilib/, "liblpsolve55j.dylib"
        s.gsub! /-llpsolve55/, "-L#{lib} -llpsolve55"
      end
      system "sh", "build-osx", "#", "lpsolve55j", "library"
      lib.install "liblpsolve55j.dylib"
    end
  end

  def numpy_include_dir
    `python -c "import numpy.distutils.misc_util as u; print(u.get_numpy_include_dirs())[0]"`.strip.to_s
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def caveats; <<~EOS
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH

    Python examples and doc are installed to #{HOMEBREW_PREFIX}/share/lp_solve
  EOS
  end

  test do
    input = <<~EOS
      max: 143 x + 60 y;

      120 x + 210 y <= 15000;
      110 x + 30 y <= 4000;
      x + y <= 75;
    EOS
    (testpath/"input.lp").write(input)
    output = `#{bin}/lp_solve -S3 input.lp`
    puts output
    match = output =~ /Value of objective function: 6315\.6250/
    raise if match.nil?
  end
end
