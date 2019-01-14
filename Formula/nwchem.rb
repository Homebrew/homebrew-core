class Nwchem < Formula
  desc "NWChem: Open Source High-Performance Computational Chemistry"
  homepage "http://www.nwchem-sw.org"
  url "https://github.com/nwchemgit/nwchem/releases/download/6.8.1-release/nwchem-6.8.1-release.revision-v6.8-133-ge032219-src.2018-06-14.tar.bz2"
  version "6.8.1"
  sha256 "23ce8241a5977a93d8224f66433851c81a08ad58a4c551858ae031485b095ab7"
  revision 3

  bottle do
    cellar :any
    sha256 "c0f5d0352634c9bde0e9c4b8eaae85ebc957e81056494cd68de260835520a2b2" => :mojave
    sha256 "5fc0cc1332f02f8562568796625ffcf2d1afb6d14f8704201a1290c394761989" => :high_sierra
    sha256 "8708819edfa216328f490560a3d03450c8b02aa635cc657275cf0831cca2726d" => :sierra
  end

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
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
      ENV["PYTHONVERSION"] = "2.7"
      pyhome = `python-config --prefix`.chomp
      ENV["PYTHONHOME"] = pyhome
      ENV["NWCHEM_LONG_PATHS"] = "Y"
      ENV["BLASOPT"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["BLAS_SIZE"] = "4"
      ENV["SCALAPACK"] = "-L#{Formula["scalapack"].opt_prefix}/lib -lscalapack"
      ENV["USE_64TO32"] = "y"
      system "make", "nwchem_config", "NWCHEM_MODULES=all python"
      system "make", "64_to_32"
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
      system "./runtests.mpi.unix", "procs", "2", "dft_he2+", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end
