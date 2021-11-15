class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https://nwchemgit.github.io"
  url "https://github.com/nwchemgit/nwchem/releases/download/v7.0.2-release/nwchem-7.0.2-release.revision-b9985dfa-src.2020-10-12.tar.bz2"
  version "7.0.2"
  sha256 "d9d19d87e70abf43d61b2d34e60c293371af60d14df4a6333bf40ea63f6dc8ce"
  license "ECL-2.0"
  revision 2

  livecheck do
    url "https://github.com/nwchemgit/nwchem.git"
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
  end

  bottle do
    sha256 cellar: :any, monterey: "bf4b2dfa17eb48b600343b6488980fd8ef988cd20bab9ad67b7e5abd82c0f076"
    sha256 cellar: :any, big_sur:  "e652f67d76cad24fc36ca61c54fec440692c493217d857604f180244e647ebab"
    sha256 cellar: :any, catalina: "c94e9afb94a3c8f8ab43bf4ffad7d1004ddd696dc56f68dfb3624023c44c0190"
  end

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.10"
  depends_on "scalapack"

  # patches for compatibility with python@3.10
  # https://github.com/nwchemgit/nwchem/issues/271
  patch do
    url "https://github.com/nwchemgit/nwchem/commit/638401361c6f294164a4f820ff867a62ac836fd5.patch?full_index=1"
    sha256 "20516447b75bde548eb7e40faafcc5d310e8236a7cd3e44f53a753ac1312530e"
  end

  patch do
    url "https://github.com/nwchemgit/nwchem/commit/cd0496c6bdd58cf2f1004e32cb39499a14c4c677.patch?full_index=1"
    sha256 "1ff3fdacdebb0f812f6f14c423053a12f2389b0208b8809f3ab401b066866ffc"
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
      ENV["PYTHONVERSION"] = Language::Python.major_minor_version "python3"
      ENV["BLASOPT"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["LAPACK_LIB"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["BLAS_SIZE"] = "4"
      ENV["SCALAPACK"] = "-L#{Formula["scalapack"].opt_prefix}/lib -lscalapack"
      ENV["USE_64TO32"] = "y"
      system "make", "nwchem_config", "NWCHEM_MODULES=all python"
      system "make", "NWCHEM_TARGET=MACX64", "USE_MPI=Y"

      bin.install "../bin/MACX64/nwchem"
      pkgshare.install "basis/libraries"
      pkgshare.install "nwpw/libraryps"
      pkgshare.install Dir["data/*"]
    end
  end

  test do
    cp_r pkgshare/"QA", testpath
    cd "QA" do
      ENV["NWCHEM_TOP"] = pkgshare
      ENV["NWCHEM_TARGET"] = "MACX64"
      ENV["NWCHEM_EXECUTABLE"] = "#{bin}/nwchem"
      system "./runtests.mpi.unix", "procs", "0", "dft_he2+", "pyqa3", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end
