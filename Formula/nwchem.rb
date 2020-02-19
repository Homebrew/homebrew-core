class Nwchem < Formula
  desc "NWChem: Open Source High-Performance Computational Chemistry"
  homepage "http://www.nwchem-sw.org"
  url "https://github.com/nwchemgit/nwchem/releases/download/v7.0.0-beta2/nwchem-7.0.0-release.revision-98b07222-src.2020-02-07.tar.bz2"
  version "7.0.0"
  sha256 "d3589c33be7b357bbea9089c3fcf190424f14c69543e0fe15ecad6482d178bf7"
  revision 0

  bottle do
    cellar :any
    sha256 "adb31aca8aab678039d4c6d573ef3f57343ae0189a3a772b2c18a804786f0100" => :catalina
    sha256 "43743133c9d7b8de119238ce698424328cda01b4e3e798f3939333bea108b21f" => :mojave
    sha256 "731ada93191900a657aab3bf378059b36ce1b4bda36f4faff2e32940ec517f48" => :high_sierra
    sha256 "2c10b964c143063de0b9513e5c036a31fd3742cdcd66073ee79729146554d929" => :sierra
  end

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"
  depends_on "python"

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
#needed to use python 3.7 to skip using default python2
      ENV["PYTHONVERSION"] = "3.7"
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
      system "./runtests.mpi.unix", "procs", "0", "dft_he2+", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end
