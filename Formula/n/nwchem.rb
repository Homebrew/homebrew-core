class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https://nwchemgit.github.io"
  url "https://github.com/nwchemgit/nwchem/releases/download/v7.2.3-release/nwchem-7.2.3-release.revision-d690e065-src.2024-08-27.tar.xz"
  version "7.2.3"
  sha256 "7788e6af9be8681e6384b8df4df5ac57d010b2c7aa50842d735c562d92f94c25"
  license "ECL-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "9e7d38520a012a3b258b13b79d2e21fa1f65c69d6a80e442db8543c301ebf8c4"
    sha256                               arm64_sonoma:  "cbd863d1ffb5625c8551e5bccae2ac62d2d09af075e9e10956033d4e3ddaa2b9"
    sha256                               arm64_ventura: "7fce8b94f1233bcf022bfaa7456abf9587baeb3319ffc47b725dd83eb1d83b6c"
    sha256 cellar: :any,                 sonoma:        "2e2473703a5f2d268135f72189557e4c150059774540e9c89c74b66774a6931f"
    sha256 cellar: :any,                 ventura:       "dd0b5829832ca473260b2da63478f93cee2e4bdf388898f0fc546e1f2e2a52f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0aa305807bdecc60ae25c0b3798ea4cc9fa9251be63dda2e7c460351106b393"
  end

  depends_on "gcc" # for gfortran
  depends_on "hwloc"
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "pkgconf"
  depends_on "python@3.13"
  depends_on "scalapack"

  uses_from_macos "libxcrypt"

  # fix download url in build_dftd3a.sh, upstream pr ref, https://github.com/nwchemgit/nwchem/pull/1054
  patch do
    url "https://github.com/nwchemgit/nwchem/commit/65ce7726d9fa418f7c01665bebfc1e2181f15adf.patch?full_index=1"
    sha256 "13410bdadc51ae60e0f6fb3a1ce4dece8a2c97a19c4e59ee027ea8443b6d3f2f"
  end

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
      ENV["PYTHONVERSION"] = Language::Python.major_minor_version "python3.13"
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
      ENV["OMP_NUM_THREADS"] = "1"
      ENV["NWCHEM_TOP"] = testpath
      ENV["NWCHEM_TARGET"] = OS.mac? ? "MACX64" : "LINUX64"
      ENV["NWCHEM_EXECUTABLE"] = bin/"nwchem"
      system "./runtests.mpi.unix", "procs", "0", "dft_he2+", "pyqa3", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end
