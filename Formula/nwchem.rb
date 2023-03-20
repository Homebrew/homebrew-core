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
    sha256                               arm64_ventura:  "6f2813bab91bb47361c3311aa00a238d5417e54e41ada9a9ff56b63dd6d2abc8"
    sha256                               arm64_monterey: "4ad3206f334c98bd0c1441ae82ee86cbab62ca401dff557fa51b7e450f079ec5"
    sha256                               arm64_big_sur:  "d57fbea35192e517e1034ff8d8504bfb54c4a259dd838317b53497ad706b4212"
    sha256 cellar: :any,                 ventura:        "c308301f1e5b07c2cc5a9de2dd35f331942ed457d928148af7bb3756985a0b40"
    sha256 cellar: :any,                 monterey:       "be5d075056247429c4483383f849928026deaad1fc37e9bcb8c8aba355885371"
    sha256 cellar: :any,                 big_sur:        "fd2032b804cf888c5db6e967ffeb9ed90d6db592392630a5c7bf5babc95330c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "685f2a62f9294bf64780b39d801121a208520857f1cbf97eaf3de07bb64eb600"
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
