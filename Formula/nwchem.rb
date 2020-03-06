class Nwchem < Formula
  desc "NWChem: Open Source High-Performance Computational Chemistry"
  homepage "http://www.nwchem-sw.org"
  url "https://github.com/nwchemgit/nwchem/releases/download/v7.0.0-release/nwchem-7.0.0-release.revision-2c9a1c7c-src.2020-02-26.tar.bz2"
  version "7.0.0"
  sha256 "1046e13a4c7f95860c8e8fac2b4d80657900ecd07a8242943d564048ce303514"
  revision 1

  bottle do
    cellar :any
    sha256 "575409db72d702fc357eaf22c80eec54c018eab3026e6971188985b7e2a9a8fd" => :catalina
    sha256 "b2a2f14b3545047841f953d7728bcd1371097d6decc73a1632f6307b9e2d9f36" => :mojave
    sha256 "daa5476f7692086dc6c2d4a42368bc73630f647ed55223f3652e675fd689f00d" => :high_sierra
  end

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.8"
  depends_on "scalapack"

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

      ENV["NWCHEM_TOP"] = buildpath
      ENV["NWCHEM_LONG_PATHS"] = "Y"
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
