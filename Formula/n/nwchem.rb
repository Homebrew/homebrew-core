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
    rebuild 1
    sha256                               arm64_sonoma:   "4eb9156a22ee832e23a448db71b7ffbdfeb69ea85d82b303d9a1c1f4f4d21562"
    sha256                               arm64_ventura:  "30538e2ebd02b9aaeecfff31a544e8d85fff5b77ac8a26209c183a3b4faa1bb5"
    sha256                               arm64_monterey: "7c8f25f671cea2e1acbc76e761471b395fbcffc8c8d450691036e62865288cd2"
    sha256 cellar: :any,                 sonoma:         "bd2ce3d93babeceded93166e6da0875ab646584dd019c2007efd007e5ae09f8d"
    sha256 cellar: :any,                 ventura:        "9899a57bae8d8f85ab38d0a4c25039763732c23ced5c25670abdae5f7b8d43fc"
    sha256 cellar: :any,                 monterey:       "1e1cc5b3326800c8b3b284ed70c0d4f0cace57d237bb43dab4e2d0c36286f7cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "043ce3262dcd5c229f86fb40c415797800fe2f920ae1abfebf1c7f276fddbaf8"
  end

  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.12"
  depends_on "scalapack"

  uses_from_macos "libxcrypt"

  # Adds Python 3.12 compatibility.
  # Remove in next release.
  patch do
    url "https://github.com/nwchemgit/nwchem/commit/48fac057df694267c2422adc2b394a0ac0815c02.patch?full_index=1"
    sha256 "5514e33185ca34c099d26806112b08c582a5f79e000184dfd1b8c9dfdd5cc1d9"
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

      inreplace "util/util_nwchemrc.F", "/etc/nwchemrc", "#{etc}/nwchemrc"

      # needed to use python 3.X to skip using default python2
      ENV["PYTHONVERSION"] = Language::Python.major_minor_version "python3.12"
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
