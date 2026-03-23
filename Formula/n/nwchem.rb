class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https://nwchemgit.github.io"
  url "https://github.com/nwchemgit/nwchem/releases/download/v7.3.1-release/nwchem-7.3.1-release.revision-23c3b41b-src.2025-11-06.tar.xz"
  version "7.3.1"
  sha256 "7bc6f9bae6e4bf45750968e97a3206b0b026eabd8aa7b5e54317a9a26afcbe60"
  license "ECL-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
    strategy :github_latest
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_tahoe:   "33fc3d51309ae901d070e2380d5a0552ff0e2a2da355c94fbc36afaa7dd46eba"
    sha256                               arm64_sequoia: "416b29913eb2e227ffb4c98bf6f62c9c8a8670db34f06fd9d8578a373d75296b"
    sha256                               arm64_sonoma:  "b45508056077a395b0deb84d4f923602fab5337d67644952d1c3b1f7140f337f"
    sha256 cellar: :any,                 sonoma:        "c037408994a20f9552262a4e1005da9639f7e23fbb7fa8f3fd2e4c211d709680"
    sha256                               arm64_linux:   "788f61cfc30939a21bdbc11cfac058565bd0a51d63ffd65d82faa75e13e2b981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daa6ff90b5ea14633f27c3f1853cbfe019c80d5e66996a5abf76d1dfbf26f8e7"
  end

  depends_on "gcc" # for gfortran
  depends_on "hwloc"
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "pkgconf"
  depends_on "python@3.14"
  depends_on "scalapack"

  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "libomp"
  end

  def install
    pkgshare.install "QA"

    cd "src" do
      # Workaround to link to LLVM OpenMP (libomp) with gfortran
      inreplace "config/makefile.h", /(\bLDOPTIONS *\+= *)-fopenmp$/, "\\1-lomp" if OS.mac?

      (prefix/"etc").mkdir
      (prefix/"etc/nwchemrc").write <<~EOS
        nwchem_basis_library #{pkgshare}/libraries/
        nwchem_nwpw_library #{pkgshare}/libraryps/
        ffield amber
        amber_1 #{pkgshare}/amber_s/
        amber_2 #{pkgshare}/amber_q/
        amber_3 #{pkgshare}/amber_x/
        amber_4 #{pkgshare}/amber_u/
        spce    #{pkgshare}/solvents/spce.rst
        charmm_s #{pkgshare}/charmm_s/
        charmm_x #{pkgshare}/charmm_x/
      EOS

      inreplace "util/util_nwchemrc.F", "/etc/nwchemrc", etc/"nwchemrc"

      # needed to use python 3.X to skip using default python2
      ENV["PYTHONVERSION"] = Language::Python.major_minor_version "python3.14"
      ENV["BLASOPT"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["LAPACK_LIB"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["BLAS_SIZE"] = "4"
      ENV["SCALAPACK"] = "-L#{Formula["scalapack"].opt_prefix}/lib -lscalapack"
      ENV["SCALAPACK_SIZE"] = "4"
      ENV["USE_64TO32"] = "y"
      ENV["USE_HWOPT"] = "n"
      ENV["OPENBLAS_USES_OPENMP"] = "y"
      ENV["LIBXC_LIB"] = Formula["libxc"].opt_lib.to_s
      ENV["LIBXC_INCLUDE"] = Formula["libxc"].opt_include.to_s
      os = OS.mac? ? "MACX64" : "LINUX64"
      system "make", "nwchem_config", "NWCHEM_MODULES=all python gwmol bsemol", "USE_MPI=Y"
      system "make", "NWCHEM_TARGET=#{os}", "USE_MPI=Y"
      bin.install "../bin/#{os}/nwchem"
      pkgshare.install "basis/libraries"
      pkgshare.install "basis/libraries.bse"
      pkgshare.install "nwpw/libraryps"
      pkgshare.install Dir["data/*"]
    end
  end

  test do
    if OS.mac?
      require "utils/linkage"
      libgomp = Formula["gcc"].opt_lib/"gcc/current/libgomp.dylib"
      refute Utils.binary_linked_to_library?(bin/"nwchem", libgomp), "Unwanted linkage to libgomp!"
    end

    cp_r pkgshare/"QA", testpath
    cd "QA" do
      ENV["OMP_NUM_THREADS"] = "1"
      ENV["NWCHEM_TOP"] = testpath
      ENV["NWCHEM_TARGET"] = OS.mac? ? "MACX64" : "LINUX64"
      ENV["NWCHEM_EXECUTABLE"] = bin/"nwchem"
      system "./runtests.mpi.unix", "procs", "0", "dft_he2+", "pyqa3", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end
