class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/releases/3.14.12.tar.gz"
  sha256 "6b06cd6280d5ca52fc97ca95adaaddd43529e6e8637c274e21ee1072c3b4577f"
  license "EPL-2.0"
  head "https://github.com/coin-or/Ipopt.git", branch: "stable/3.14"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a4faa74c116c600b9cddcd14c3261ebd15bb22fcc225169b943734f0c8665f0"
    sha256 cellar: :any,                 arm64_monterey: "eca3d43412eb195d3400dc43d5e1763c0788a6539fada79bfffc098b6f44006b"
    sha256 cellar: :any,                 arm64_big_sur:  "b5a0e77969ed03a2677b398731bdb626022824f345fc449422b7f2acdaea840f"
    sha256 cellar: :any,                 ventura:        "d1ee49c596e2a87e69e62fdc90348886b6c6f1a2a749615011500697b96db19c"
    sha256 cellar: :any,                 monterey:       "7ed9526e8b28640832c8131c4dba3d624a1557f4bce7f24c31306a37a0a52fd9"
    sha256 cellar: :any,                 big_sur:        "464bc75765bd684fcfeb138881c34664a9eb944d299a892160309b9e8c55d0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f20b121f0eb35819601c90c92afb09111a5fee07fb4b1b0355c311ab46cc2e01"
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "ampl-mp"
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  resource "mumps" do
    # follow links provided in official repo: https://github.com/coin-or-tools/ThirdParty-Mumps/blob/stable/3.0/get.Mumps
    url "http://coin-or-tools.github.io/ThirdParty-Mumps/MUMPS_5.5.1.tar.gz"
    mirror "http://deb.debian.org/debian/pool/main/m/mumps/mumps_5.5.1.orig.tar.gz"
    sha256 "1abff294fa47ee4cfd50dfd5c595942b72ebfcedce08142a75a99ab35014fa15"

    patch do
      # MUMPS does not provide a Makefile.inc customized for macOS.
      on_macos do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/ab96a8b8e510a8a022808a9be77174179ac79e85/ipopt/mumps-makefile-inc-generic-seq.patch"
        sha256 "0c570ee41299073ec2232ad089d8ee10a2010e6dfc9edc28f66912dae6999d75"
      end

      on_linux do
        url "https://gist.githubusercontent.com/dawidd6/09f831daf608eb6e07cc80286b483030/raw/b5ab689dea5772e9b6a8b6d88676e8d76224c0cc/mumps-homebrew-linux.patch"
        sha256 "13125be766a22aec395166bf015973f5e4d82cd3329c87895646f0aefda9e78e"
      end
    end
  end

  resource "test" do
    url "https://github.com/coin-or/Ipopt/archive/releases/3.14.12.tar.gz"
    sha256 "6b06cd6280d5ca52fc97ca95adaaddd43529e6e8637c274e21ee1072c3b4577f"
  end

  def install
    ENV.delete("MPICC")
    ENV.delete("MPICXX")
    ENV.delete("MPIFC")

    resource("mumps").stage do
      cp "Make.inc/Makefile.inc.generic.SEQ", "Makefile.inc"
      inreplace "Makefile.inc", "@rpath/", "#{opt_lib}/" if OS.mac?

      # Fix for GCC 10
      inreplace "Makefile.inc", "OPTF    = -fPIC",
                "OPTF    = -fPIC -fallow-argument-mismatch"

      ENV.deparallelize { system "make", "d" }

      (buildpath/"mumps_include").install Dir["include/*.h", "libseq/mpi.h"]
      lib.install Dir[
        "lib/#{shared_library("*")}",
        "libseq/#{shared_library("*")}",
        "PORD/lib/#{shared_library("*")}"
      ]
    end

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--enable-shared",
      "--prefix=#{prefix}",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-mumps-cflags=-I#{buildpath}/mumps_include",
      "--with-mumps-lflags=-L#{lib} -ldmumps -lmpiseq -lmumps_common -lopenblas -lpord",
      "--with-asl-cflags=-I#{Formula["ampl-mp"].opt_include}/asl",
      "--with-asl-lflags=-L#{Formula["ampl-mp"].opt_lib} -lasl",
    ]

    system "./configure", *args
    system "make"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    testpath.install resource("test")
    pkg_config_flags = `pkg-config --cflags --libs ipopt`.chomp.split
    system ENV.cxx, "examples/hs071_cpp/hs071_main.cpp", "examples/hs071_cpp/hs071_nlp.cpp", *pkg_config_flags
    system "./a.out"
    system "#{bin}/ipopt", "#{Formula["ampl-mp"].opt_pkgshare}/example/wb"
  end
end
