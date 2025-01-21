class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.17.tar.gz"
  sha256 "17ab8e9a6059ab11172c184e5947e7a7dda9fed0764764779c27e5b8e46f3d75"
  license "EPL-2.0"
  head "https://github.com/coin-or/Ipopt.git", branch: "stable/3.14"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "28f86d6ab4e46e32df53b0d84ea2bc8da41fe2493d8659f9f113e221587292e7"
    sha256 cellar: :any,                 arm64_sonoma:  "e0da5c979f401e853212ee3318729532f8bcb29b289dc13027aeb91a10f1ccfe"
    sha256 cellar: :any,                 arm64_ventura: "0430a197a189b0173c8a291595f5603a5732a465219113ae7600da3e704ecf78"
    sha256 cellar: :any,                 sonoma:        "945bcc0d98610c8f333c8d67bbe38efe6f784fd072ea1912ae62767d3090b4b8"
    sha256 cellar: :any,                 ventura:       "59158e254001660ae93cf61f6afb569cc5742617e590e9c8ce337c597d4caa28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cba5cbe25680d7bf7d4dbfdbcc7c730981aefef2104d8b4de2846d566094f33"
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
    url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.17.tar.gz"
    sha256 "17ab8e9a6059ab11172c184e5947e7a7dda9fed0764764779c27e5b8e46f3d75"
  end

  resource "miniampl" do
    url "https://github.com/dpo/miniampl/archive/refs/tags/v1.0.tar.gz"
    sha256 "b836dbf1208426f4bd93d6d79d632c6f5619054279ac33453825e036a915c675"
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
    testpath.install resource("test")
    pkgconf_flags = shell_output("pkgconf --cflags --libs ipopt").chomp.split
    system ENV.cxx, "examples/hs071_cpp/hs071_main.cpp", "examples/hs071_cpp/hs071_nlp.cpp", *pkgconf_flags
    system "./a.out"

    resource("miniampl").stage do
      system bin/"ipopt", "examples/wb"
    end
  end
end
