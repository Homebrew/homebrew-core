class Modflow6 < Formula
  desc "USGS modular hydrologic model"
  homepage "https://www.usgs.gov/software/modflow-6-usgs-modular-hydrologic-model"
  url "https://github.com/MODFLOW-ORG/modflow6/archive/refs/tags/6.8.0.tar.gz"
  sha256 "e031d000eeacba00238421379e98dbcb1d4928fedaa4d9665d92932eb33dbaed"
  license "CC0-1.0"
  head "https://github.com/MODFLOW-ORG/modflow6.git", branch: "develop"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gcc" # for gfortran

  deny_network_access!

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # mf5to6 is a separate meson project that the top-level meson.build does not include
    system "meson", "setup", "build_mf5to6", "utils/mf5to6", *std_meson_args
    system "meson", "compile", "-C", "build_mf5to6", "--verbose"
    system "meson", "install", "-C", "build_mf5to6"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mf6 --version")

    # steady-state flow between constant heads of 10 and 1 in a row of ten cells
    (testpath/"mfsim.nam").write <<~EOS
      BEGIN timing
        TDIS6 sim.tdis
      END timing
      BEGIN models
        GWF6 model.nam model
      END models
      BEGIN exchanges
      END exchanges
      BEGIN solutiongroup 1
        IMS6 sim.ims model
      END solutiongroup
    EOS
    (testpath/"sim.tdis").write <<~EOS
      BEGIN dimensions
        NPER 1
      END dimensions
      BEGIN perioddata
        1.0 1 1.0
      END perioddata
    EOS
    (testpath/"sim.ims").write <<~EOS
      BEGIN linear
        INNER_DVCLOSE 1.0e-9
        INNER_RCLOSE 1.0e-9
      END linear
    EOS
    (testpath/"model.nam").write <<~EOS
      BEGIN options
        SAVE_FLOWS
      END options
      BEGIN packages
        DIS6 model.dis
        IC6 model.ic
        NPF6 model.npf
        CHD6 model.chd
        OC6 model.oc
      END packages
    EOS
    (testpath/"model.dis").write <<~EOS
      BEGIN dimensions
        NLAY 1
        NROW 1
        NCOL 10
      END dimensions
      BEGIN griddata
        DELR
          CONSTANT 1.0
        DELC
          CONSTANT 1.0
        TOP
          CONSTANT 1.0
        BOTM
          CONSTANT 0.0
      END griddata
    EOS
    (testpath/"model.ic").write <<~EOS
      BEGIN griddata
        STRT
          CONSTANT 0.0
      END griddata
    EOS
    (testpath/"model.npf").write <<~EOS
      BEGIN griddata
        ICELLTYPE
          CONSTANT 0
        K
          CONSTANT 1.0
      END griddata
    EOS
    (testpath/"model.chd").write <<~EOS
      BEGIN dimensions
        MAXBOUND 2
      END dimensions
      BEGIN period 1
        1 1 1 10.0
        1 1 10 1.0
      END period
    EOS
    (testpath/"model.oc").write <<~EOS
      BEGIN options
        HEAD FILEOUT model.hds
        BUDGET FILEOUT model.cbc
      END options
      BEGIN period 1
        SAVE HEAD ALL
        SAVE BUDGET ALL
      END period
    EOS

    system bin/"mf6"
    assert_match "Normal termination of simulation", (testpath/"mfsim.lst").read

    # the head record follows a 52-byte header
    heads = (testpath/"model.hds").binread.unpack("x52E10")
    10.downto(1).zip(heads).each { |expected, head| assert_in_delta expected, head, 1e-6 }

    # zone budget of that simulation, with a zone for each half of the row
    (testpath/"zbud.nam").write <<~EOS
      BEGIN ZONEBUDGET
        BUD model.cbc
        ZON model.zon
        GRB model.dis.grb
      END ZONEBUDGET
    EOS
    (testpath/"model.zon").write <<~EOS
      BEGIN DIMENSIONS
        NCELLS 10
      END DIMENSIONS
      BEGIN GRIDDATA
        IZONE
          INTERNAL FACTOR 1
            1 1 1 1 1 2 2 2 2 2
      END GRIDDATA
    EOS

    system bin/"zbud6", "zbud.nam"
    assert_match "Normal Termination", (testpath/"zbud.lst").read

    # unit conductance and gradient, so the flow from zone 1 to zone 2 is 1
    rows = (testpath/"zbud.csv").read.lines.map { |line| line.strip.split(",") }
    assert_in_delta 1.0, rows[1][rows[0].index("TO ZONE 2")].to_f, 1e-6

    # convert the same model written as MODFLOW-2005 input, then run the result
    (testpath/"mf2005").mkpath
    (testpath/"mf2005/model.nam").write <<~EOS
      LIST 10 model.lst
      DIS 11 model.dis
      BAS6 12 model.ba6
      LPF 13 model.lpf
      PCG 14 model.pcg
      OC 15 model.oc
      DATA(BINARY) 30 model.hds REPLACE
    EOS
    (testpath/"mf2005/model.dis").write <<~EOS
      1 1 10 1 4 2
      0
      CONSTANT 1.0
      CONSTANT 1.0
      CONSTANT 1.0
      CONSTANT 0.0
      1.0 1 1.0 SS
    EOS
    (testpath/"mf2005/model.ba6").write <<~EOS
      FREE
      CONSTANT -1
       -999.99
      CONSTANT 1.0
    EOS
    (testpath/"mf2005/model.lpf").write <<~EOS
      0 -999.0 0
      0
      0
      1.0
      0
      0
      CONSTANT 1.0
      CONSTANT 1.0
    EOS
    (testpath/"mf2005/model.pcg").write <<~EOS
      50 30 1
      0.001 0.001 1.0 1 0 0 1.0
    EOS
    (testpath/"mf2005/model.oc").write <<~EOS
      HEAD SAVE UNIT 30
      PERIOD 1 STEP 1
        SAVE HEAD
    EOS

    cd testpath/"mf2005" do
      assert_match "Conversion successful", shell_output("#{bin}/mf5to6 model.nam mf6")
      system bin/"mf6"
      assert_match "Normal termination of simulation", (testpath/"mf2005/mfsim.lst").read
    end
  end
end
