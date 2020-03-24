class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https://openfast.readthedocs.io"
  url "https://github.com/openfast/openfast/archive/v2.3.0.tar.gz"
  sha256 "2b368e8c8211ebed03e87fb3e89ef733b7e4be4848834da4034f8419d618446c"

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "openblas"

  def install
    args = std_cmake_args + %w[
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
      -DBLA_VENDOR=OpenBLAS
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "openfast"
      bin.install "glue-codes/openfast/openfast"
    end
  end

  test do
    (testpath/"homebrew.fst").write <<~EOS
      ------- OpenFAST INPUT FILE ----------------------------------------------------
      Simple test case to validate Homebrew installation
      ---------------------- SIMULATION CONTROL --------------------------------------
      False         Echo            - Echo input data to <RootName>.ech (flag)
      "FATAL"       AbortLevel      - Error level when simulation should abort (string) {"WARNING", "SEVERE", "FATAL"}
            0.01   TMax            - Total run time (s)
            0.005   DT              - Recommended module time step (s)
                2   InterpOrder     - Interpolation order for input/output time history (-) {1=linear, 2=quadratic}
                0   NumCrctn        - Number of correction iterations (-) {0=explicit calculation, i.e., no corrections}
            99999   DT_UJac         - Time between calls to get Jacobians (s)
            1E+06   UJacSclFact     - Scaling factor used in Jacobians (-)
      ---------------------- FEATURE SWITCHES AND FLAGS ------------------------------
                1   CompElast       - Compute structural dynamics (switch) {1=ElastoDyn; 2=ElastoDyn + BeamDyn for blades}
                0   CompInflow      - Compute inflow wind velocities (switch) {0=still air; 1=InflowWind; 2=external from OpenFOAM}
                0   CompAero        - Compute aerodynamic loads (switch) {0=None; 1=AeroDyn v14; 2=AeroDyn v15}
                0   CompServo       - Compute control and electrical-drive dynamics (switch) {0=None; 1=ServoDyn}
                0   CompHydro       - Compute hydrodynamic loads (switch) {0=None; 1=HydroDyn}
                0   CompSub         - Compute sub-structural dynamics (switch) {0=None; 1=SubDyn; 2=External Platform MCKF}
                0   CompMooring     - Compute mooring system (switch) {0=None; 1=MAP++; 2=FEAMooring; 3=MoorDyn; 4=OrcaFlex}
                0   CompIce         - Compute ice loads (switch) {0=None; 1=IceFloe; 2=IceDyn}
      ---------------------- INPUT FILES ---------------------------------------------
      "elastodyn.dat"    EDFile          - Name of file containing ElastoDyn input parameters (quoted string)
      "unused"      BDBldFile(1)    - Name of file containing BeamDyn input parameters for blade 1 (quoted string)
      "unused"      BDBldFile(2)    - Name of file containing BeamDyn input parameters for blade 2 (quoted string)
      "unused"      BDBldFile(3)    - Name of file containing BeamDyn input parameters for blade 3 (quoted string)
      "unused"      InflowFile      - Name of file containing inflow wind input parameters (quoted string)
      "unused"      AeroFile        - Name of file containing aerodynamic input parameters (quoted string)
      "unused"      ServoFile       - Name of file containing control and electrical-drive input parameters (quoted string)
      "unused"      HydroFile       - Name of file containing hydrodynamic input parameters (quoted string)
      "unused"      SubFile         - Name of file containing sub-structural input parameters (quoted string)
      "unused"      MooringFile     - Name of file containing mooring system input parameters (quoted string)
      "unused"      IceFile         - Name of file containing ice input parameters (quoted string)
      ---------------------- OUTPUT --------------------------------------------------
      False         SumPrint        - Print summary data to "<RootName>.sum" (flag)
                5   SttsTime        - Amount of time between screen status messages (s)
            99999   ChkptTime       - Amount of time between creating checkpoint files for potential restart (s)
            0.005   DT_Out          - Time step for tabular output (s) (or "default")
                0   TStart          - Time to begin tabular output (s)
                1   OutFileFmt      - Format for tabular (time-marching) output file (switch) {1: text file [<RootName>.out], 2: binary file [<RootName>.outb], 3: both}
      True          TabDelim        - Use tab delimiters in text tabular output file? (flag) {uses spaces if false}
      "ES10.3E2"    OutFmt          - Format used for text tabular output, excluding the time channel.  Resulting field should be 10 characters. (quoted string)
      ---------------------- LINEARIZATION -------------------------------------------
      False         Linearize       - Linearization analysis (flag)
                2   NLinTimes       - Number of times to linearize (-) [>=1] [unused if Linearize=False]
              30,         60    LinTimes        - List of times at which to linearize (s) [1 to NLinTimes] [unused if Linearize=False]
                1   LinInputs       - Inputs included in linearization (switch) {0=none; 1=standard; 2=all module inputs (debug)} [unused if Linearize=False]
                1   LinOutputs      - Outputs included in linearization (switch) {0=none; 1=from OutList(s); 2=all module outputs (debug)} [unused if Linearize=False]
      False         LinOutJac       - Include full Jacobians in linearization output (for debug) (flag) [unused if Linearize=False; used only if LinInputs=LinOutputs=2]
      False         LinOutMod       - Write module-level linearization output files in addition to output for full system? (flag) [unused if Linearize=False]
      ---------------------- VISUALIZATION ------------------------------------------
                0   WrVTK           - VTK visualization data output: (switch) {0=none; 1=initialization data only; 2=animation}
                2   VTK_type        - Type of VTK visualization data: (switch) {1=surfaces; 2=basic meshes (lines/points); 3=all meshes (debug)} [unused if WrVTK=0]
      false         VTK_fields      - Write mesh fields to VTK data files? (flag) {true/false} [unused if WrVTK=0]
              15   VTK_fps         - Frame rate for VTK output (frames per second){will use closest integer multiple of DT} [used only if WrVTK=2]
    EOS

    (testpath/"blade.dat").write <<~EOS
      ------- ELASTODYN V1.00.* INDIVIDUAL BLADE INPUT FILE --------------------------
      AOC 15/50 blade file.  GJStiff -> EdgEAof are mostly lies.
      ---------------------- BLADE PARAMETERS ----------------------------------------
              11   NBlInpSt    - Number of blade input stations (-)
                4   BldFlDmp(1) - Blade flap mode #1 structural damping in percent of critical (%)
                4   BldFlDmp(2) - Blade flap mode #2 structural damping in percent of critical (%)
                4   BldEdDmp(1) - Blade edge mode #1 structural damping in percent of critical (%)
      ---------------------- BLADE ADJUSTMENT FACTORS --------------------------------
                1   FlStTunr(1) - Blade flapwise modal stiffness tuner, 1st mode (-)
                1   FlStTunr(2) - Blade flapwise modal stiffness tuner, 2nd mode (-)
                1   AdjBlMs     - Factor to adjust blade mass density (-)
                1   AdjFlSt     - Factor to adjust blade flap stiffness (-)
                1   AdjEdSt     - Factor to adjust blade edge stiffness (-)
      ---------------------- DISTRIBUTED BLADE PROPERTIES ----------------------------
          BlFract      PitchAxis      StrcTwst       BMassDen        FlpStff        EdgStff
            (-)           (-)          (deg)          (kg/m)         (Nm^2)         (Nm^2)
      0.0000000E+00  2.5000000E-01  7.6900000E+00  4.9750000E+01  8.2448500E+06  7.6431600E+06
      1.0000000E-01  2.5000000E-01  5.3500000E+00  3.3570000E+01  5.7297000E+06  1.0364760E+07
      2.0000000E-01  2.5000000E-01  4.6600000E+00  2.1680000E+01  2.6900000E+06  1.0999800E+07
      3.0000000E-01  2.5000000E-01  4.3100000E+00  2.2890000E+01  1.9233500E+06  1.2632760E+07
      4.0000000E-01  2.5000000E-01  3.9100000E+00  1.8990000E+01  1.3988000E+06  1.1158560E+07
      5.0000000E-01  2.5000000E-01  3.2500000E+00  1.6800000E+01  8.8770000E+05  5.8968000E+06
      6.0000000E-01  2.5000000E-01  2.5600000E+00  1.5590000E+01  4.9899500E+05  3.8329200E+06
      7.0000000E-01  2.5000000E-01  1.8600000E+00  1.2370000E+01  2.5017000E+05  2.3360400E+06
      8.0000000E-01  2.5000000E-01  1.1600000E+00  1.1240000E+01  8.2314000E+04  1.1748240E+06
      9.0000000E-01  2.5000000E-01  7.3000000E-01  1.0110000E+01  5.5818000E+04  9.0720000E+05
      1.0000000E+00  2.5000000E-01  3.5000000E-01  8.9800000E+00  2.9456000E+04  6.4184400E+05
      ---------------------- BLADE MODE SHAPES ---------------------------------------
          0.2506   BldFl1Sh(2) - Flap mode 1, coeff of x^2
            1.215   BldFl1Sh(3) -            , coeff of x^3
          -2.0261   BldFl1Sh(4) -            , coeff of x^4
          2.7203   BldFl1Sh(5) -            , coeff of x^5
          -1.1598   BldFl1Sh(6) -            , coeff of x^6
          -2.3421   BldFl2Sh(2) - Flap mode 2, coeff of x^2
          5.0047   BldFl2Sh(3) -            , coeff of x^3
        -25.9119   BldFl2Sh(4) -            , coeff of x^4
          40.8648   BldFl2Sh(5) -            , coeff of x^5
        -16.6154   BldFl2Sh(6) -            , coeff of x^6
          1.8381   BldEdgSh(2) - Edge mode 1, coeff of x^2
          -2.0103   BldEdgSh(3) -            , coeff of x^3
          0.9662   BldEdgSh(4) -            , coeff of x^4
          0.9933   BldEdgSh(5) -            , coeff of x^5
          -0.7874   BldEdgSh(6) -            , coeff of x^6
    EOS

    (testpath/"tower.dat").write <<~EOS
      ------- ELASTODYN V1.00.* TOWER INPUT FILE -------------------------------------
      AOC tower data.  This is pure fiction.
      ---------------------- TOWER PARAMETERS ----------------------------------------
              11   NTwInpSt    - Number of input stations to specify tower geometry
                3   TwrFADmp(1) - Tower 1st fore-aft mode structural damping ratio (%)
                3   TwrFADmp(2) - Tower 2nd fore-aft mode structural damping ratio (%)
                3   TwrSSDmp(1) - Tower 1st side-to-side mode structural damping ratio (%)
                3   TwrSSDmp(2) - Tower 2nd side-to-side mode structural damping ratio (%)
      ---------------------- TOWER ADJUSTMUNT FACTORS --------------------------------
                1   FAStTunr(1) - Tower fore-aft modal stiffness tuner, 1st mode (-)
                1   FAStTunr(2) - Tower fore-aft modal stiffness tuner, 2nd mode (-)
                1   SSStTunr(1) - Tower side-to-side stiffness tuner, 1st mode (-)
                1   SSStTunr(2) - Tower side-to-side stiffness tuner, 2nd mode (-)
                1   AdjTwMa     - Factor to adjust tower mass density (-)
                1   AdjFASt     - Factor to adjust tower fore-aft stiffness (-)
                1   AdjSSSt     - Factor to adjust tower side-to-side stiffness (-)
      ---------------------- DISTRIBUTED TOWER PROPERTIES ----------------------------
        HtFract       TMassDen         TwFAStif       TwSSStif
        (-)           (kg/m)           (Nm^2)         (Nm^2)
      0.0000000E+00  1.5110000E+02  2.3500000E+09  2.3500000E+09
      1.0000000E-01  1.4170000E+02  2.1200000E+09  2.1200000E+09
      2.0000000E-01  1.3560000E+02  1.8800000E+09  1.8800000E+09
      3.0000000E-01  1.3220000E+02  1.6500000E+09  1.6500000E+09
      4.0000000E-01  1.3070000E+02  1.4200000E+09  1.4200000E+09
      5.0000000E-01  1.3030000E+02  1.1900000E+09  1.1900000E+09
      6.0000000E-01  1.3030000E+02  9.5700000E+08  9.5700000E+08
      7.0000000E-01  1.2980000E+02  7.2600000E+08  7.2600000E+08
      8.0000000E-01  1.2820000E+02  4.9400000E+08  4.9400000E+08
      9.0000000E-01  1.2460000E+02  2.6200000E+08  2.6200000E+08
      1.0000000E+00  1.1840000E+02  3.0000000E+07  3.0000000E+07
      ---------------------- TOWER FORE-AFT MODE SHAPES ------------------------------
          1.0495   TwFAM1Sh(2) - Mode 1, coefficient of x^2 term
          0.0694   TwFAM1Sh(3) -       , coefficient of x^3 term
          -0.289   TwFAM1Sh(4) -       , coefficient of x^4 term
          0.3003   TwFAM1Sh(5) -       , coefficient of x^5 term
          -0.1301   TwFAM1Sh(6) -       , coefficient of x^6 term
        -25.1012   TwFAM2Sh(2) - Mode 2, coefficient of x^2 term
          20.1243   TwFAM2Sh(3) -       , coefficient of x^3 term
          0.9012   TwFAM2Sh(4) -       , coefficient of x^4 term
          16.6452   TwFAM2Sh(5) -       , coefficient of x^5 term
        -11.5696   TwFAM2Sh(6) -       , coefficient of x^6 term
      ---------------------- TOWER SIDE-TO-SIDE MODE SHAPES --------------------------
          1.0495   TwSSM1Sh(2) - Mode 1, coefficient of x^2 term
          0.0694   TwSSM1Sh(3) -       , coefficient of x^3 term
          -0.289   TwSSM1Sh(4) -       , coefficient of x^4 term
          0.3003   TwSSM1Sh(5) -       , coefficient of x^5 term
          -0.1301   TwSSM1Sh(6) -       , coefficient of x^6 term
        -25.1012   TwSSM2Sh(2) - Mode 2, coefficient of x^2 term
          20.1243   TwSSM2Sh(3) -       , coefficient of x^3 term
          0.9012   TwSSM2Sh(4) -       , coefficient of x^4 term
          16.6452   TwSSM2Sh(5) -       , coefficient of x^5 term
        -11.5696   TwSSM2Sh(6) -       , coefficient of x^6 term
    EOS

    (testpath/"elastodyn.dat").write <<~EOS
      ------- ELASTODYN v1.03.* INPUT FILE -------------------------------------------
      FAST certification Test #08: AOC 15/50 with many DOFs with fixed yaw error and steady wind. Many parameters are pure fiction.
      ---------------------- SIMULATION CONTROL --------------------------------------
      False         Echo        - Echo input data to "<RootName>.ech" (flag)
                3   Method      - Integration method: {1: RK4, 2: AB4, or 3: ABM4} (-)
            0.005   DT          - Integration time step (s)
      ---------------------- ENVIRONMENTAL CONDITION ---------------------------------
          9.80665   Gravity     - Gravitational acceleration (m/s^2)
      ---------------------- DEGREES OF FREEDOM --------------------------------------
      True          FlapDOF1    - First flapwise blade mode DOF (flag)
      True          FlapDOF2    - Second flapwise blade mode DOF (flag)
      True          EdgeDOF     - First edgewise blade mode DOF (flag)
      False         TeetDOF     - Rotor-teeter DOF (flag) [unused for 3 blades]
      False         DrTrDOF     - Drivetrain rotational-flexibility DOF (flag)
      False         GenDOF      - Generator DOF (flag)
      False         YawDOF      - Yaw DOF (flag)
      True          TwFADOF1    - First fore-aft tower bending-mode DOF (flag)
      True          TwFADOF2    - Second fore-aft tower bending-mode DOF (flag)
      True          TwSSDOF1    - First side-to-side tower bending-mode DOF (flag)
      True          TwSSDOF2    - Second side-to-side tower bending-mode DOF (flag)
      False         PtfmSgDOF   - Platform horizontal surge translation DOF (flag)
      False         PtfmSwDOF   - Platform horizontal sway translation DOF (flag)
      False         PtfmHvDOF   - Platform vertical heave translation DOF (flag)
      False         PtfmRDOF    - Platform roll tilt rotation DOF (flag)
      False         PtfmPDOF    - Platform pitch tilt rotation DOF (flag)
      False         PtfmYDOF    - Platform yaw rotation DOF (flag)
      ---------------------- INITIAL CONDITIONS --------------------------------------
                0   OoPDefl     - Initial out-of-plane blade-tip displacement (meters)
                0   IPDefl      - Initial in-plane blade-tip deflection (meters)
            1.54   BlPitch(1)  - Blade 1 initial pitch (degrees)
            1.54   BlPitch(2)  - Blade 2 initial pitch (degrees)
            1.54   BlPitch(3)  - Blade 3 initial pitch (degrees) [unused for 2 blades]
                0   TeetDefl    - Initial or fixed teeter angle (degrees) [unused for 3 blades]
                0   Azimuth     - Initial azimuth angle for blade 1 (degrees)
            64.14   RotSpeed    - Initial or fixed rotor speed (rpm)
              -15   NacYaw      - Initial or fixed nacelle-yaw angle (degrees)
                0   TTDspFA     - Initial fore-aft tower-top displacement (meters)
                0   TTDspSS     - Initial side-to-side tower-top displacement (meters)
                0   PtfmSurge   - Initial or fixed horizontal surge translational displacement of platform (meters)
                0   PtfmSway    - Initial or fixed horizontal sway translational displacement of platform (meters)
                0   PtfmHeave   - Initial or fixed vertical heave translational displacement of platform (meters)
                0   PtfmRoll    - Initial or fixed roll tilt rotational displacement of platform (degrees)
                0   PtfmPitch   - Initial or fixed pitch tilt rotational displacement of platform (degrees)
                0   PtfmYaw     - Initial or fixed yaw rotational displacement of platform (degrees)
      ---------------------- TURBINE CONFIGURATION -----------------------------------
                3   NumBl       - Number of blades (-)
            7.49   TipRad      - The distance from the rotor apex to the blade tip (meters)
            0.28   HubRad      - The distance from the rotor apex to the blade root (meters)
                6   PreCone(1)  - Blade 1 cone angle (degrees)
                6   PreCone(2)  - Blade 2 cone angle (degrees)
                6   PreCone(3)  - Blade 3 cone angle (degrees) [unused for 2 blades]
                0   HubCM       - Distance from rotor apex to hub mass [positive downwind] (meters)
                0   UndSling    - Undersling length [distance from teeter pin to the rotor apex] (meters) [unused for 3 blades]
                0   Delta3      - Delta-3 angle for teetering rotors (degrees) [unused for 3 blades]
                0   AzimB1Up    - Azimuth value to use for I/O when blade 1 points up (degrees)
            1.341   OverHang    - Distance from yaw axis to rotor apex [3 blades] or teeter pin [2 blades] (meters)
              0.5   ShftGagL    - Distance from rotor apex [3 blades] or teeter pin [2 blades] to shaft strain gages [positive for upwind rotors] (meters)
                0   ShftTilt    - Rotor shaft tilt angle (degrees)
                0   NacCMxn     - Downwind distance from the tower-top to the nacelle CM (meters)
                0   NacCMyn     - Lateral  distance from the tower-top to the nacelle CM (meters)
              0.6   NacCMzn     - Vertical distance from the tower-top to the nacelle CM (meters)
                0   NcIMUxn     - Downwind distance from the tower-top to the nacelle IMU (meters)
                0   NcIMUyn     - Lateral  distance from the tower-top to the nacelle IMU (meters)
                0   NcIMUzn     - Vertical distance from the tower-top to the nacelle IMU (meters)
              0.6   Twr2Shft    - Vertical distance from the tower-top to the rotor shaft (meters)
            24.4   TowerHt     - Height of tower above ground level [onshore] or MSL [offshore] (meters)
                0   TowerBsHt   - Height of tower base above ground level [onshore] or MSL [offshore] (meters)
                0   PtfmCMxt    - Downwind distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)
                0   PtfmCMyt    - Lateral distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)
              -0   PtfmCMzt    - Vertical distance from the ground level [onshore] or MSL [offshore] to the platform CM (meters)
              -0   PtfmRefzt   - Vertical distance from the ground level [onshore] or MSL [offshore] to the platform reference point (meters)
      ---------------------- MASS AND INERTIA ----------------------------------------
              5.9   TipMass(1)  - Tip-brake mass, blade 1 (kg)
              5.9   TipMass(2)  - Tip-brake mass, blade 2 (kg)
              5.9   TipMass(3)  - Tip-brake mass, blade 3 (kg) [unused for 2 blades]
            247.3   HubMass     - Hub mass (kg)
                9   HubIner     - Hub inertia about rotor axis [3 blades] or teeter axis [2 blades] (kg m^2)
              10   GenIner     - Generator inertia about HSS (kg m^2)
            1747   NacMass     - Nacelle mass (kg)
            976.3   NacYIner    - Nacelle inertia about yaw axis (kg m^2)
                0   YawBrMass   - Yaw bearing mass (kg)
                0   PtfmMass    - Platform mass (kg)
                0   PtfmRIner   - Platform inertia for roll tilt rotation about the platform CM (kg m^2)
                0   PtfmPIner   - Platform inertia for pitch tilt rotation about the platform CM (kg m^2)
                0   PtfmYIner   - Platform inertia for yaw rotation about the platform CM (kg m^2)
      ---------------------- BLADE ---------------------------------------------------
              10   BldNodes    - Number of blade nodes (per blade) used for analysis (-)
      "blade.dat"    BldFile(1)  - Name of file containing properties for blade 1 (quoted string)
      "blade.dat"    BldFile(2)  - Name of file containing properties for blade 2 (quoted string)
      "blade.dat"    BldFile(3)  - Name of file containing properties for blade 3 (quoted string) [unused for 2 blades]
      ---------------------- ROTOR-TEETER --------------------------------------------
                0   TeetMod     - Rotor-teeter spring/damper model {0: none, 1: standard, 2: user-defined from routine UserTeet} (switch) [unused for 3 blades]
                0   TeetDmpP    - Rotor-teeter damper position (degrees) [used only for 2 blades and when TeetMod=1]
                0   TeetDmp     - Rotor-teeter damping constant (N-m/(rad/s)) [used only for 2 blades and when TeetMod=1]
                0   TeetCDmp    - Rotor-teeter rate-independent Coulomb-damping moment (N-m) [used only for 2 blades and when TeetMod=1]
                0   TeetSStP    - Rotor-teeter soft-stop position (degrees) [used only for 2 blades and when TeetMod=1]
                0   TeetHStP    - Rotor-teeter hard-stop position (degrees) [used only for 2 blades and when TeetMod=1]
                0   TeetSSSp    - Rotor-teeter soft-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]
                0   TeetHSSp    - Rotor-teeter hard-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]
      ---------------------- DRIVETRAIN ----------------------------------------------
              100   GBoxEff     - Gearbox efficiency (%)
            28.25   GBRatio     - Gearbox ratio (-)
          600000   DTTorSpr    - Drivetrain torsional spring (N-m/rad)
          100000   DTTorDmp    - Drivetrain torsional damper (N-m/(rad/s))
      ---------------------- FURLING -------------------------------------------------
      False         Furling     - Read in additional model properties for furling turbine (flag) [must currently be FALSE)
      "unused"      FurlFile    - Name of file containing furling properties (quoted string) [unused when Furling=False]
      ---------------------- TOWER ---------------------------------------------------
              11   TwrNodes    - Number of tower nodes used for analysis (-)
      "tower.dat"    TwrFile     - Name of file containing tower properties (quoted string)
      ---------------------- OUTPUT --------------------------------------------------
      False         SumPrint    - Print summary data to "<RootName>.sum" (flag)
                1   OutFile     - Switch to determine where output will be placed: {1: in module output file only; 2: in glue code output file only; 3: both} (currently unused)
      True          TabDelim    - Use tab delimiters in text tabular output file? (flag) (currently unused)
      "ES10.3E2"    OutFmt      - Format used for text tabular output (except time).  Resulting field should be 10 characters. (quoted string) (currently unused)
              10   TStart      - Time to begin tabular output (s) (currently unused)
              10   DecFact     - Decimation factor for tabular output {1: output every time step} (-) (currently unused)
                0   NTwGages    - Number of tower nodes that have strain gages for output [0 to 9] (-)
                0   TwrGagNd    - List of tower nodes that have strain gages [1 to TwrNodes] (-) [unused if NTwGages=0]
                2   NBlGages    - Number of blade nodes that have strain gages for output [0 to 9] (-)
                2,          6    BldGagNd    - List of blade nodes that have strain gages [1 to BldNodes] (-) [unused if NBlGages=0]
                    OutList     - The next line(s) contains a list of output parameters.  See OutListParameters.xlsx for a listing of available output channels, (-)
      "TipDxb1"                 - Blade flapwise tip deflections
      "TipDxb2"                 - Blade flapwise tip deflections
      "TipDyb1"                 - Blade edgewise tip deflections
      "TipDyb2"                 - Blade edgewise tip deflections
      END of input file (the word "END" must appear in the first 3 columns of this last OutList line)
      ---------------------------------------------------------------------------------------
    EOS

    system bin/"openfast", "homebrew.fst"
    assert_predicate testpath/"homebrew.out", :exist?
  end
end
