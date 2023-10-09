class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https://nwchemgit.github.io"
  url "https://github.com/nwchemgit/nwchem/releases/download/v7.2.1-release/nwchem-7.2.1-release.revision-487f8b94-src.2023-10-04.tar.bz2"
  version "7.2.1"
  sha256 "ee3f0da0bb8f9b366dc6960d79af61bbfead3290779c77b975b1df020394c6ad"
  license "ECL-2.0"

  livecheck do
    url "https://github.com/nwchemgit/nwchem.git"
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "fa51b1d6159223c778baaabfc7255d530fd7885fed8f82b433b76cbd993ff2bd"
    sha256                               arm64_ventura:  "49feebe33dd9fc9fafc5f9f2ad0edb5569bbd4d5080a1d665059a0efcf6f5566"
    sha256                               arm64_monterey: "68acc32acfe7e12dae050d15b77ccf1744de3fdf2dc8be400233cb0854d353bb"
    sha256 cellar: :any,                 sonoma:         "aef4ed42571e2f40aeec5ea6b59f630dee35d0632c1b754c01459a1a01464a42"
    sha256 cellar: :any,                 ventura:        "93cf8d200d93c25c59e07d2387fe7d776b302fda896d3c35a0ba096ebeeefdbe"
    sha256 cellar: :any,                 monterey:       "c890742717e4ae516f98db6a9426d99b5c7b9de60b02fddd56fbfcd3c4c0fc6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7581f3f8b6edf5666ecb0fb63af2e785d730497c60e23a61d0e2a14c58f91a2"
  end

  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.11"
  depends_on "scalapack"

  uses_from_macos "libxcrypt"

  def install
    pkgshare.install "QA"

    cd "src" do
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

      inreplace "util/util_nwchemrc.F", "/etc/nwchemrc", "#{etc}/nwchemrc"

      # needed to use python 3.X to skip using default python2
      ENV["PYTHONVERSION"] = Language::Python.major_minor_version "python3.11"
      ENV["BLASOPT"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["LAPACK_LIB"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["BLAS_SIZE"] = "4"
      ENV["SCALAPACK"] = "-L#{Formula["scalapack"].opt_prefix}/lib -lscalapack"
      ENV["SCALAPACK_SIZE"] = "4"
      ENV["USE_64TO32"] = "y"
      ENV["USE_HWOPT"] = "n"
      ENV["LIBXC_LIB"] = Formula["libxc"].opt_lib.to_s
      ENV["LIBXC_INCLUDE"] = Formula["libxc"].opt_include.to_s
      ENV.append "OMPI_FCFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500
      ENV.append "OMPI_CFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500
      os = OS.mac? ? "MACX64" : "LINUX64"
      system "make", "nwchem_config", "NWCHEM_MODULES=all python gwmol", "USE_MPI=Y"
      system "make", "NWCHEM_TARGET=#{os}", "USE_MPI=Y"

      bin.install "../bin/#{os}/nwchem"
      pkgshare.install "basis/libraries"
      pkgshare.install "basis/libraries.bse"
      pkgshare.install "nwpw/libraryps"
      pkgshare.install Dir["data/*"]
    end
  end

  test do
    cp_r pkgshare/"QA", testpath
    cd "QA" do
      ENV["NWCHEM_TOP"] = testpath
      ENV["NWCHEM_TARGET"] = OS.mac? ? "MACX64" : "LINUX64"
      ENV["NWCHEM_EXECUTABLE"] = "#{bin}/nwchem"
      system "./runtests.mpi.unix", "procs", "0", "dft_he2+", "pyqa3", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end
