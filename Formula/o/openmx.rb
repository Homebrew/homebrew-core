class Openmx < Formula
  desc "DFT package for large-scale material simulations"
  homepage "https://www.openmx-square.org/"
  url "https://www.openmx-square.org/openmx4.0.tar.gz"
  version "4.0.1"
  sha256 "8d5338faf70885f276352bbd2826cdfed2ffd08f33eca58752666d79a7d0c3bf"
  license "GPL-3.0-only"

  livecheck do
    url "https://www.openmx-square.org/download.html"
    regex(/href=.*?(?:openmx|patch)[._-]?v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"

  on_macos do
    depends_on "libomp"
  end

  resource "patch4.0.1" do
    url "https://www.openmx-square.org/bugfixed/26May08/patch4.0.1.tar.gz"
    sha256 "c5312eeee13e17e0123beeb4eb2379bcf7c7cafa1815b1dcf6846452f9620bef"
  end

  def install
    resource("patch4.0.1").stage do
      cp "Band_DFT_Dosout.c", buildpath/"source/Band_DFT_Dosout.c"
      cp "Mulliken_Charge.c", buildpath/"source/Mulliken_Charge.c"
      cp "GaAs.dat", buildpath/"work/GaAs.dat"
    end

    data_path = opt_pkgshare/"DFT_DATA19"

    ENV["OMPI_FC"] = (formula_opt_bin("gcc")/"gfortran").to_s

    mpicc = formula_opt_bin("open-mpi")/"mpicc"
    mpif90 = formula_opt_bin("open-mpi")/"mpif90"
    elpa = buildpath/"source/elpa-2018.05.001"
    stagebin = buildpath/"stage/bin"
    mkdir_p stagebin

    cc = "#{mpicc} -O2 -fcommon -I#{formula_opt_include("fftw")} -I#{elpa}"
    fc = "#{mpif90} -O2 -fallow-argument-mismatch -I#{elpa}"
    libs = "-L#{formula_opt_lib("scalapack")} -L#{formula_opt_lib("openblas")} " \
           "-L#{formula_opt_lib("fftw")} " \
           "-lscalapack -lopenblas -lfftw3"

    cc += " -Dnosse" if Hardware::CPU.arm?

    if OS.mac?
      # Clang treats these legacy C diagnostics as errors.
      cc += " -Wno-implicit-function-declaration -Wno-incompatible-function-pointer-types " \
            "-Xpreprocessor -fopenmp -I#{formula_opt_include("libomp")}"
      fc += " -fopenmp"
      libs += " -L#{formula_opt_lib("libomp")} -lomp"
    else
      cc += " -fopenmp"
      fc += " -fopenmp"
      libs += " -fopenmp"
    end

    ENV.deparallelize

    cd "source" do
      inreplace "Input_std.c", "../DFT_DATA19", data_path.to_s
      inreplace "cif2omx.c", "DATA.PATH                     ./", "DATA.PATH                     #{data_path}"
      # Keep this helper local without defining kcomp, which disables ELPA2 paths.
      inreplace "Set_ProExpn_VNA.c", "inline void Spherical_Bessel2", "static inline void Spherical_Bessel2"

      # Link through mpif90 so its runtime libraries do not need to be listed manually.
      inreplace "makefile",
                "\t$(CC) $(OBJS) $(LIB) -lm -o openmx",
                "\t#{mpif90} $(OBJS) $(LIB) -lm -o openmx",
                global: false

      system "make", "all",
             "CC=#{cc}",
             "FC=#{fc}",
             "LIB=#{libs}",
             "DESTDIR=#{stagebin}"
    end

    staged_bins = stagebin.children.sort_by(&:to_s)
    odie "no OpenMX binaries were staged" if staged_bins.empty?
    bin.install staged_bins

    pkgshare.install "DFT_DATA19"
    Dir["work/**/*.dat"].each do |dat|
      next unless File.binread(dat).include?("DATA.PATH".b)

      inreplace dat, /^DATA\.PATH\s+.*/, "DATA.PATH                     #{data_path}"
    end
    (pkgshare/"examples").install "work"
  end

  test do
    ENV["OMP_NUM_THREADS"] = "2"

    cp pkgshare/"examples/work/Methane.dat", testpath/"Methane.dat"

    mpirun = formula_opt_bin("open-mpi")/"mpirun"
    output = shell_output("#{mpirun} -np 2 #{bin}/openmx Methane.dat -nt 2")
    assert_match "The calculation was normally finished", output
    met_out = (testpath/"met.out").read
    assert_match "Total Computational Time", met_out
    expected_utot = (pkgshare/"examples/work/input_example/Methane.out").read[/^\s*Utot\.\s+(-?\d+\.\d+)/, 1]
    utot = met_out[/^\s*Utot\.\s+(-?\d+\.\d+)/, 1]
    assert expected_utot, "Utot was not found in upstream Methane.out"
    assert utot, "Utot was not written to met.out"
    assert_in_delta(expected_utot.to_f, utot.to_f, 1e-6)
  end
end
