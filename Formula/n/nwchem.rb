class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https://nwchemgit.github.io"
  url "https://github.com/nwchemgit/nwchem/releases/download/v7.3.1-release/nwchem-7.3.1-release.revision-23c3b41b-src.2025-11-06.tar.xz"
  version "7.3.1"
  sha256 "7bc6f9bae6e4bf45750968e97a3206b0b026eabd8aa7b5e54317a9a26afcbe60"
  license "ECL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
    strategy :github_latest
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256                               arm64_tahoe:   "954e8393c1e675dd1fd472151f8f09262aaa695139a4c1ef7a8f9338c989f5ad"
    sha256                               arm64_sequoia: "7ae2ce68fa21a12535252186aef8b0637afb7ad843dec38683994afb7b54a06c"
    sha256                               arm64_sonoma:  "4fd81543886acd86fb770ad330b6b3a924ef11733bd9346b40567de49513fabe"
    sha256 cellar: :any,                 sonoma:        "9d5376f4c3c69d949a44da05f796ec85aaa9e9efa728ba857a5cf9fc9d893715"
    sha256                               arm64_linux:   "b9178a4091dbe5915a185bae713c9f7776ab75ef760d43e29b1c42bd324c987c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02d6237051cbc357a67c05782d316bc33ca96dcbf87066b70026bb87f40d4b06"
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
