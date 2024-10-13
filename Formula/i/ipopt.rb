class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.16.tar.gz"
  sha256 "cc8c217991240db7eb14189eee0dff88f20a89bac11958b48625fa512fe8d104"
  license "EPL-2.0"
  head "https://github.com/coin-or/Ipopt.git", branch: "stable/3.14"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "009c5caaad3fe3b204c0428bbb99037ee7c814ea2c908566721215099983420c"
    sha256 cellar: :any,                 arm64_sonoma:   "7ab15709c6d8d0911bac33f38b65f047766108a3b291b8f00a6ce765e9db0fc3"
    sha256 cellar: :any,                 arm64_ventura:  "f7ee0132a291e546eb7e0cf1be44b4a453896a96af88ce091e9e622b9def7914"
    sha256 cellar: :any,                 arm64_monterey: "2b8567b6ed6a773a7c5e1506d6dd0c7928d985a1f105907eceabe00dc43f4fe1"
    sha256 cellar: :any,                 sonoma:         "16cd7b2d2c01d59f4882ba61649da6c9c1f90ce08e3fae3cc3b26eae9016afc6"
    sha256 cellar: :any,                 ventura:        "9d25a0a32684759aed13bb1dd854437d9f4a21b02531652aa7af202bc2eec8c7"
    sha256 cellar: :any,                 monterey:       "a6523b45e35985d5e080eed53398ad47ef7c7a3d4bb0b0cc78c2c5620fdade11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3807673210056f3d94d69ca81ec6321b80376c48de6015b93b29692ab5d409"
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "ampl-mp"
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  resource "mumps" do
    # follow links provided in official repo: https://github.com/coin-or-tools/ThirdParty-Mumps/blob/stable/3.0/get.Mumps
    url "https://coin-or-tools.github.io/ThirdParty-Mumps/MUMPS_5.6.2.tar.gz"
    mirror "https://deb.debian.org/debian/pool/main/m/mumps/mumps_5.6.2.orig.tar.gz"
    sha256 "13a2c1aff2bd1aa92fe84b7b35d88f43434019963ca09ef7e8c90821a8f1d59a"

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
    url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.16.tar.gz"
    sha256 "cc8c217991240db7eb14189eee0dff88f20a89bac11958b48625fa512fe8d104"
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
    system bin/"ipopt", "#{Formula["ampl-mp"].opt_pkgshare}/example/wb"
  end
end
