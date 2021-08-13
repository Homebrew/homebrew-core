class Openstructure < Formula
  desc "Open-Source Computational Structural Biology Framework"
  homepage "https://www.openstructure.org"
  url "https://git.scicore.unibas.ch/schwede/openstructure/-/archive/2.2.0/openstructure-2.2.0.tar.bz2"
  sha256 "7006f6c034cc4b67fd8bc8635215a4252df6b2b48e1c1bfefa2e20a6ffd41b2d"
  license "LGPL-3.0-only"
  head "https://git.scicore.unibas.ch/schwede/openstructure.git"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "brewsci/bio/clustal-w"
  depends_on "brewsci/bio/dssp"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python@3.9"
  depends_on "scipy"
  depends_on "sqlite"
  depends_on "swig"

  uses_from_macos "zlib"

  conflicts_with "brewsci/bio/tmalign",
    because: "both install `tmalign` binaries"

  def install
    mkdir "build" do
      on_macos do
        ENV.append "LDFLAGS", "-undefined dynamic_lookup"
        ENV["SDKROOT"] = MacOS.sdk_path
        ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
      end

      flag = "-Wno-return-type"
      # set -DENABLE_MM=OFF because openmm is currently unavailable on PyPI.
      # set -DENABLE_GUI=OFF because qt@5 causes segmentation fault on macOS.
      args = std_cmake_args + %W[
        -DCMAKE_C_FLAGS=#{flag}
        -DCMAKE_CXX_FLAGS=#{flag}
        -DOPTIMIZE=ON
        -DCOMPILE_TMTOOLS=1
        -DENABLE_MM=OFF
        -DUSE_SHADER=ON
        -DUSE_NUMPY=1
        -DENABLE_GFX=ON
        -DENABLE_GUI=OFF
      ]

      # CMake picks up the system's python shared library, even if we have a brewed one.
      py3ver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
      py3prefix = Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{py3ver}"
      on_linux do
        py3prefix = Formula["python@3.9"].opt_prefix
      end

      ENV["PYTHONPATH"] = lib/"python#{py3ver}/site-packages"

      args << "-DPython_ROOT_DIR=#{Formula["python@3.9"].opt_prefix}"
      args << "-DPython_LIBRARIES=#{py3prefix}/lib/#{shared_library("libpython#{py3ver}")}"
      args << "-DPython_INCLUDE_DIRS=#{py3prefix}/include/python#{py3ver}"

      system "cmake", "..", *args
      system "make"
      system "make", "install", "PYTHON_LDFLAGS=-undefined dynamic_lookup"
      (pkgshare/"conop/data").install "../modules/conop/data/charmm.cif"
    end
  end

  def caveats
    <<~EOS
      You need to download components.cif.gz and compile it to run lddt:
        curl -OL http://ftp.wwpdb.org/pub/pdb/data/monomers/components.cif.gz
        chemdict_tool create components.cif.gz compounds.chemlib pdb
        chemdict_tool update #{share}/conop/data/charmm.cif compounds.chemlib charmm
        mv compounds.chemlib #{share}/openstructure/
    EOS
  end

  test do
    assert_match("\n Brief instruction for running", shell_output("#{bin}/tmalign").chomp)
  end
end
