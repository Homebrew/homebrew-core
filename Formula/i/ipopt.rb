class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.20.tar.gz"
  sha256 "43bddd6fa793b1694aa94d6129fe3e4a8d452d97a84ef5f2ff721c8047c75605"
  license "EPL-2.0"
  compatibility_version 1
  head "https://github.com/coin-or/Ipopt.git", branch: "stable/3.14"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6d411466685323eaf4fdfbefd4da8dbb35c7a20c844b8221ce62466debe96362"
    sha256 cellar: :any, arm64_tahoe:       "e4b7041cb746ff1320d6106736541a4e2de198683cbfd425430ed720e6c1f1b8"
    sha256 cellar: :any, arm64_sequoia:     "8920dc5c3ce9bb6a7394111af6a136c3a9569f39c073c5825d6e3aeac33c2448"
    sha256 cellar: :any, arm64_sonoma:      "f8743bed926e11ceb367300edcf3ffbc94f22011449348953b92daa404b63ee7"
    sha256 cellar: :any, arm64_linux:       "d4e412e60add7a503b878dbd1d145d7cc5a67885294a3de3e17810477b1ae294"
    sha256 cellar: :any, x86_64_linux:      "822e41f4859327dc1beb834e1ccc1a50da15befee522c3b77003d0ce2260b860"
  end

  depends_on "openjdk" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "ampl-asl"
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
        file "Patches/ipopt/mumps-makefile-inc-generic-seq.patch"
      end

      on_linux do
        url "https://gist.githubusercontent.com/dawidd6/09f831daf608eb6e07cc80286b483030/raw/b5ab689dea5772e9b6a8b6d88676e8d76224c0cc/mumps-homebrew-linux.patch"
        sha256 "13125be766a22aec395166bf015973f5e4d82cd3329c87895646f0aefda9e78e"
        type :unofficial
      end
    end
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
        "PORD/lib/#{shared_library("*")}",
      ]
    end

    args = [
      "--disable-silent-rules",
      "--enable-shared",
      "--with-blas=-L#{formula_opt_lib("openblas")} -lopenblas",
      "--with-mumps-cflags=-I#{buildpath}/mumps_include",
      "--with-mumps-lflags=-L#{lib} -ldmumps -lmpiseq -lmumps_common -lopenblas -lpord",
      "--with-asl-cflags=-I#{formula_opt_include("ampl-asl")}/asl",
      "--with-asl-lflags=-L#{formula_opt_lib("ampl-asl")} -lasl",
    ]

    system "./configure", *args, *std_configure_args
    system "make"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    resource "test" do
      url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.19.tar.gz"
      sha256 "b3eb84a23812b53a3325bcd2c599de2b0f5df45a18ed251f9e3c1cd893136287"
    end

    resource "miniampl" do
      url "https://github.com/dpo/miniampl/archive/refs/tags/v1.0.tar.gz"
      sha256 "b836dbf1208426f4bd93d6d79d632c6f5619054279ac33453825e036a915c675"
    end

    testpath.install resource("test")
    pkgconf_flags = shell_output("pkgconf --cflags --libs ipopt").chomp.split
    system ENV.cxx, "examples/hs071_cpp/hs071_main.cpp", "examples/hs071_cpp/hs071_nlp.cpp", *pkgconf_flags
    system "./a.out"

    resource("miniampl").stage do
      system bin/"ipopt", "examples/wb"
    end
  end
end
