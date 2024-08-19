class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https://nwchemgit.github.io"
  url "https://github.com/nwchemgit/nwchem/releases/download/v7.2.2-release/nwchem-7.2.2-release.revision-74936fb9-src.2023-11-03.tar.xz"
  version "7.2.2"
  sha256 "037e8c80a946683d10f995a4b5eff7d8247b3c28cf1158f8f752fd2cb49227c5"
  license "ECL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256                               arm64_sonoma:   "3abde846447d77e53b52cc25c22a526f6aeaa05ba6ea50aea0071076b2c0c9e2"
    sha256                               arm64_ventura:  "13b783dbbe729ec08f3c86d70cbc313c6e3fd48b92427ed11a6723b952620be0"
    sha256                               arm64_monterey: "1f24264743a058117b4f66b4bf4c4ce3ed4cca904c12d21f0a6596a508bec7ee"
    sha256 cellar: :any,                 sonoma:         "5f08344628651f052a4eeb75629efd8563c3c80e1cc7b064284ff35200b4ab4b"
    sha256 cellar: :any,                 ventura:        "a5642c7083957b97c70b2d224e77c6688c4a5924c65879ace1ed04fd83976ceb"
    sha256 cellar: :any,                 monterey:       "59ebcfc7e40cff5ce8add809d4e3f20bfcd3f9be8e3d4041c5e7944d499aae5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b928b2fffea97b3246c994e1fb21d72bed9240eef621231decfcf8c7711dee88"
  end

  depends_on "gcc" # for gfortran
  depends_on "hwloc"
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

  # fix for Py_SetProgramName deprecated by python 3.11
  # Remove in next release.
  patch do
    url "https://github.com/nwchemgit/nwchem/commit/c6851de6a771a31d387e06819fce26b49391b20b.patch?full_index=1"
    sha256 "558b4f25013b91f29b2740e4d26fa6ebae861260d8ddd169c89aea255b49b7ea"
  end

  # fix for python 3.13
  # Remove in next release.
  patch do
    url "https://github.com/nwchemgit/nwchem/commit/bc18d20d90ba1fd6efc894558bef2fdacaac28a8.patch?full_index=1"
    sha256 "5432e8b0af47e80efb22f11774738e578919f5f857a7a3e46138a173910269d7"
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

      inreplace "util/util_nwchemrc.F", "/etc/nwchemrc", etc/"nwchemrc"

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
      cd "tools" do
        system "make", "NWCHEM_TARGET=#{os}", "USE_MPI=Y"
      end
      mkdir_p "../bin/#{os}"
      system ENV.cc, "config/depend.c", "-o", "../bin/#{os}/depend.x"
      system "make", "USE_INTERNALBLAS=1", "deps_stamp", "NWCHEM_TARGET=#{os}", "USE_MPI=Y"
      ENV["QUICK_BUILD"] = "1"
      system "make", "NWCHEM_TARGET=#{os}", "USE_MPI=Y"
      ENV.delete("QUICK_BUILD")
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
      ENV["NWCHEM_EXECUTABLE"] = bin/"nwchem"
      system "./runtests.mpi.unix", "procs", "0", "dft_he2+", "pyqa3", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end
