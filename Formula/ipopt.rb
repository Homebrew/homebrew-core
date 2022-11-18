class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/releases/3.14.10.tar.gz"
  sha256 "b73d705ca05a8fb47392ca7e31c4da81ae7d0eb751767cd04ba2bb19b7f140f9"
  license "EPL-2.0"
  head "https://github.com/coin-or/Ipopt.git", branch: "stable/3.14"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fc6c7bedde96fc35648977b139512b362fad725ca0b077ae81d8e9837482d327"
    sha256 cellar: :any,                 arm64_monterey: "54cc1b57236969fdad45f1a4ff73e29fdf9e4af58d1dabf3d01a446218b8a0ab"
    sha256 cellar: :any,                 arm64_big_sur:  "71167535aa241013a89e28d0c4ca501761c4994a17999637b3eb6f5e66b61970"
    sha256 cellar: :any,                 ventura:        "e0a8be6bf66a7de0e71a1e043a1dcce27beaa0581b105ba4cc1012049576b6be"
    sha256 cellar: :any,                 monterey:       "b3e367d33c22743a10561b46eabe72fc6ecee6f56901840dc479d6d52befe676"
    sha256 cellar: :any,                 big_sur:        "387e60fa1f4d813ec635220969acdcca2ac30de74b4982a8b4f794207403f7fb"
    sha256 cellar: :any,                 catalina:       "64ab6e5f56bc1b193a94335556bae4eeef7d608eb1ab874b90619c0125211770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bfa118f7d03e87f06c80658508068138bd49b94935788a1c59ea8c1e7e94519"
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
    url "https://github.com/coin-or/Ipopt/archive/releases/3.14.10.tar.gz"
    sha256 "b73d705ca05a8fb47392ca7e31c4da81ae7d0eb751767cd04ba2bb19b7f140f9"
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
