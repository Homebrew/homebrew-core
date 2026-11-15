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
    rebuild 1
    sha256               arm64_golden_gate: "ce8d58d355bac801d51f476424c5964ac05c2a13ffa52a10341e47494ae5cbc4"
    sha256               arm64_tahoe:       "4f0a72a0caa660856a63e20299e4000a3e53e471a0c69e5f602f0aa6a6c1745a"
    sha256               arm64_sequoia:     "591154d0b15beb8ec7b3a34e99fd9347fc6ec36acb3fb9e99c5a64f5babe72a9"
    sha256               arm64_linux:       "84d10f68d851190e20fb56db4fdd2911aa49de40030c59cecfc33855f62d0d64"
    sha256 cellar: :any, x86_64_linux:      "442e692a141f900119a581092133b12a43ed7274b4e88a06dc552e6c234e187a"
  end

  depends_on "gcc" # for gfortran
  depends_on "hwloc"
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "pkgconf"
  depends_on "python@3.15"
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
      ENV["PYTHONVERSION"] = Language::Python.major_minor_version python3
      ENV["BLASOPT"] = "-L#{formula_opt_lib("openblas")} -lopenblas"
      ENV["LAPACK_LIB"] = "-L#{formula_opt_lib("openblas")} -lopenblas"
      ENV["BLAS_SIZE"] = "4"
      ENV["SCALAPACK"] = "-L#{formula_opt_prefix("scalapack")}/lib -lscalapack"
      ENV["SCALAPACK_SIZE"] = "4"
      ENV["USE_64TO32"] = "y"
      ENV["USE_HWOPT"] = "n"
      ENV["OPENBLAS_USES_OPENMP"] = "y"
      ENV["LIBXC_LIB"] = formula_opt_lib("libxc").to_s
      ENV["LIBXC_INCLUDE"] = formula_opt_include("libxc").to_s
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
      libgomp = formula_opt_lib("gcc")/"gcc/current/libgomp.dylib"
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
