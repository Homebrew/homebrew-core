class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.19.tar.gz"
  sha256 "b3eb84a23812b53a3325bcd2c599de2b0f5df45a18ed251f9e3c1cd893136287"
  license "EPL-2.0"
  head "https://github.com/coin-or/Ipopt.git", branch: "stable/3.14"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94e96fc9b70faed386353442a5dbd7eb65cbca7d2eedb0d114d81781c3346702"
    sha256 cellar: :any,                 arm64_sequoia: "847ce7b7dcfa69ea27a65ea01ac98cbe63d211d93b3075d44c75074824ac6c0c"
    sha256 cellar: :any,                 arm64_sonoma:  "1f471be987f9e4a2b010f555ae5b9b06c5177feb05932e83814355534695f8ef"
    sha256 cellar: :any,                 arm64_ventura: "ba168fca35523f7b6b75b04704fb22df58cc0ca2009a61e0de09647867ad7239"
    sha256 cellar: :any,                 sonoma:        "df6a8e87d831c760a26ea98ca037c2c6d4bb37d7520ce62e68e2aa1aa53b616e"
    sha256 cellar: :any,                 ventura:       "c5f584f91a6ae167306fae8f28574657d304643460e58a44d7edf3793c1dd960"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51378444ce9b3c3dc91f94b3744f8a287a41ad62f0c12b51e728d94a1eaf2c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "546246a14d77bcd0401489732f9d8a43ce62b74aaede0bc88ac502f79d3c6f3c"
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
        url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/ipopt/mumps-makefile-inc-generic-seq.patch"
        sha256 "0c570ee41299073ec2232ad089d8ee10a2010e6dfc9edc28f66912dae6999d75"
      end

      on_linux do
        url "https://gist.githubusercontent.com/dawidd6/09f831daf608eb6e07cc80286b483030/raw/b5ab689dea5772e9b6a8b6d88676e8d76224c0cc/mumps-homebrew-linux.patch"
        sha256 "13125be766a22aec395166bf015973f5e4d82cd3329c87895646f0aefda9e78e"
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
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-mumps-cflags=-I#{buildpath}/mumps_include",
      "--with-mumps-lflags=-L#{lib} -ldmumps -lmpiseq -lmumps_common -lopenblas -lpord",
      "--with-asl-cflags=-I#{Formula["ampl-asl"].opt_include}/asl",
      "--with-asl-lflags=-L#{Formula["ampl-asl"].opt_lib} -lasl",
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
