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
    rebuild 1
    sha256                               arm64_monterey: "63aabcfc390ff5aa3cf872ff0ee6e6cd1fb75cdf0a3da6df7c2515ed1f7de2d6"
    sha256                               arm64_big_sur:  "b30f1132a0fd8ecd3eeabbc1f45637145a0a95b347cf95d1d5cc8ba9a8fce704"
    sha256 cellar: :any,                 monterey:       "c35a3ccb7357594a5a0aa8f9410776ea384d34f963add6c42b531a776b6e95c5"
    sha256 cellar: :any,                 big_sur:        "e5bef2e09f142f35742c347b444e6e7a45633d2cb3ee5ab196a0ab2f0afa9f6c"
    sha256 cellar: :any,                 catalina:       "edf054a05656d2a6a237c223c874b13ee23fc7de474e2490cee6f5e2457f0d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "501330e4f24341e8dbe3108144c52e50909703e8626c7c995b72614f704d0619"
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
      ENV["PYTHONVERSION"] = Language::Python.major_minor_version "python3"
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
