class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https://nwchemgit.github.io"
  url "https://github.com/nwchemgit/nwchem/releases/download/v7.0.2-release/nwchem-7.0.2-release.revision-b9985dfa-src.2020-10-12.tar.bz2"
  version "7.0.2"
  sha256 "d9d19d87e70abf43d61b2d34e60c293371af60d14df4a6333bf40ea63f6dc8ce"
  license "ECL-2.0"
  revision 3

  livecheck do
    url "https://github.com/nwchemgit/nwchem.git"
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
  end

  bottle do
    sha256                               arm64_monterey: "b4b262343bb2b678facc095654f787c6963f8ff8a20a8727093e10efa13e6047"
    sha256                               arm64_big_sur:  "decb7b643ef4ffd44491e4b1d60c0b3df718a479b68458358a9a37fdb28667d3"
    sha256 cellar: :any,                 monterey:       "ecb6487a0bc0ac99a2d092efadc98d0739b0cf8fe1e6e498e690a2acee6a9aca"
    sha256 cellar: :any,                 big_sur:        "16df077bcd74a4fd905d04cdcbea7260a1428100e5013683d7eefd0e1ba40950"
    sha256 cellar: :any,                 catalina:       "a61a616252a0eed0803906342e9a029036d61fcfd2ed74dc0cd821fa46a6b8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcf7c222de7248364da410571123cdf2cbe1384e529f1ed4243fe2fb79a61179"
  end

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.10"
  depends_on "scalapack"

  uses_from_macos "libxcrypt"

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

  # patch for compatibility with ARM
  patch do
    url "https://github.com/nwchemgit/nwchem/commit/2a14c04f.patch?full_index=1"
    sha256 "3a14bb5312861948a468a02a0a079a730e8d9db98d2f2758076f9cd649a6fc04"
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
      ENV["PYTHONVERSION"] = Language::Python.major_minor_version "python3.10"
      ENV["BLASOPT"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["LAPACK_LIB"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["BLAS_SIZE"] = "4"
      ENV["SCALAPACK"] = "-L#{Formula["scalapack"].opt_prefix}/lib -lscalapack"
      ENV["USE_64TO32"] = "y"
      os = OS.mac? ? "MACX64" : "LINUX64"
      system "make", "nwchem_config", "NWCHEM_MODULES=all python"
      system "make", "NWCHEM_TARGET=#{os}", "USE_MPI=Y"

      bin.install "../bin/#{os}/nwchem"
      pkgshare.install "basis/libraries"
      pkgshare.install "nwpw/libraryps"
      pkgshare.install Dir["data/*"]
    end
  end

  test do
    cp_r pkgshare/"QA", testpath
    cd "QA" do
      ENV["NWCHEM_TOP"] = pkgshare
      ENV["NWCHEM_TARGET"] = OS.mac? ? "MACX64" : "LINUX64"
      ENV["NWCHEM_EXECUTABLE"] = "#{bin}/nwchem"
      system "./runtests.mpi.unix", "procs", "0", "dft_he2+", "pyqa3", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end
