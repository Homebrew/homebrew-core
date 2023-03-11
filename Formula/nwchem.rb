class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https://nwchemgit.github.io"
  url "https://github.com/nwchemgit/nwchem/releases/download/v7.2.0-release/nwchem-7.2.0-release.revision-d0d141fd-src.2023-03-10.tar.bz2"
  version "7.2.0"
  sha256 "f756073ab3206571a22ec26cc95dac674fed9c4c959f444b8a97df059ffa3456"
  license "ECL-2.0"

  livecheck do
    url "https://github.com/nwchemgit/nwchem.git"
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "efd545915c4c2d455f6b43676ba1c34a94f5e0e58b8fab628fb877f5a7eed20b"
    sha256                               arm64_monterey: "00018cb677e46b5257182b09ef70fa02674147fb1294cd8fbf4272a525b40a30"
    sha256                               arm64_big_sur:  "2a894ac9816fa7e546a46622e06ed35ca00affdc069a38cb43f4b2cc24ec2112"
    sha256 cellar: :any,                 ventura:        "019b2dfd3faeab131a2d5a3da7ae85ffd651fba32f9849d4c2cf8f78f7476d00"
    sha256 cellar: :any,                 monterey:       "64304c9b016e4828a06b18ecd237f4518d0de1859a9e08f2ed469475ab686aea"
    sha256 cellar: :any,                 big_sur:        "621772f44a79bc6cb9b6800456e30ea72c64ad93d4af166f6e1e2425cd5af20c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "691c2244a0dcfc7484fd9d1248968fa59638f5fed36ae36e003372c6468b5461"
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
