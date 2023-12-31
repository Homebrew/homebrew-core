class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https://nwchemgit.github.io"
  url "https://github.com/nwchemgit/nwchem/releases/download/v7.2.2-release/nwchem-7.2.2-release.revision-74936fb9-src.2023-11-03.tar.xz"
  version "7.2.2"
  sha256 "037e8c80a946683d10f995a4b5eff7d8247b3c28cf1158f8f752fd2cb49227c5"
  license "ECL-2.0"

  livecheck do
    url "https://github.com/nwchemgit/nwchem.git"
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "4d5cc2bccfbe731da0c195519ed4f42b4c9e56df48fc2870111ef99b348d73bc"
    sha256                               arm64_ventura:  "888d004b64558e5e916c836c223a4c1c34e3d6b8db9b2e229d6530955ba51656"
    sha256                               arm64_monterey: "6083f98be0f32c7274d8012cc569f677c5285732e42ba3fa186305d91ea3d60e"
    sha256 cellar: :any,                 sonoma:         "d7ec0f6a3e2c28721f4d55b74c84193c48949e4e8f3bd39d518e21f95627bdf0"
    sha256 cellar: :any,                 ventura:        "e7e429a8fb73aa1cc03b917942feed3660520429609043effce850f9bdf12473"
    sha256 cellar: :any,                 monterey:       "6deff211539b7cf1f454f5f42513886b43f621f833b2f2886ff8a79a0859f02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fda12e6b4c4b6bf084bcd3cb50d6b54d899c63fe16b54b0e1144865dd62bde5"
  end

  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "pkg-config"
  depends_on "python@3.12"
  depends_on "scalapack"

  uses_from_macos "libxcrypt"

  # fixes a performance issue due to the fact that homembrew uses OpenMP for OpenBLAS threading
  # Remove in next release.
  patch do
    url "https://github.com/nwchemgit/nwchem/commit/7ffbf689ceba4258cfe656cf979e783ee8debcdd.patch?full_index=1"
    sha256 "fcfc2b505a3afb0cc234cd0ac587c09c4d74e295f24496c899db7dc09dc7029b"
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
      ENV["NWCHEM_EXECUTABLE"] = "#{bin}/nwchem"
      system "./runtests.mpi.unix", "procs", "0", "dft_he2+", "pyqa3", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end
