class CsoundPlugins < Formula
  desc "Additional opcodes for Csound"
  homepage "https://github.com/csound/plugins"
  url "https://github.com/csound/plugins/archive/refs/tags/7.0.0.tar.gz"
  sha256 "5f00ccc3fa28437d2206bbf49136ec0a4fa0f0fd2104f56506232c49219b0df9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_golden_gate: "a5d7fb7c2700679a0407972da0607d7540bac9cc5fcbd8a0fad48279d9fa4dc4"
    sha256 arm64_tahoe:       "b00abf374beaf23b853c36b37984c8234ff470ade121aff86c77ec9f1ada60e7"
    sha256 arm64_sequoia:     "076029ed4d523b26b5e5502b181ff8830cc91128aa61f8120e2d498fde314048"
    sha256 arm64_linux:       "2fedac6766cca16f17f4d1277e0d2e4392051c4a12c6a3f3803b9e5ccc50b252"
    sha256 x86_64_linux:      "fb84be7e950b4f30dd3d5e9c14e9c2d3afa6b744f64fb33b3ad99b766320a7b7"
  end

  depends_on "cmake" => :build
  depends_on "csound"
  depends_on "faust"
  depends_on "fluid-synth"
  depends_on "hdf5"
  depends_on "libpng"
  depends_on "libwebsockets"
  depends_on "openssl@4"
  depends_on "python@3.15"
  depends_on "stk"
  depends_on "wiiuse"

  # Fix non-configurable install location by setting PLUGIN_INSTALL_DIR as a CMake cache entry
  patch do
    url "https://github.com/csound/plugins/commit/94d6dd6feaec8ce1b08fc2f4f21f3e8a9566e4a5.patch?full_index=1"
    sha256 "9c45c643ced98ff3203292b6a534250ceb68d22c695f3ffb56bf58b835746b01"
    type :backport
    resolves "https://github.com/csound/plugins/pull/12"
  end

  def install
    # Must match the plugin search path compiled into `csound`
    install_dir = lib/"csound/plugins64-#{Formula["csound"].version.major_minor}"

    args = %W[
      -DBUILD_CHUA_OPCODES=OFF
      -DBUILD_CUDA_OPCODES=OFF
      -DBUILD_FAUST_OPCODES=ON
      -DBUILD_FLUID_OPCODES=ON
      -DBUILD_HDF5_OPCODES=ON
      -DBUILD_IMAGE_OPCODES=ON
      -DBUILD_LINEAR_ALGEBRA_OPCODES=ON
      -DBUILD_OPENCL_OPCODES=OFF
      -DBUILD_PYTHON_OPCODES=ON
      -DBUILD_STK_OPCODES=ON
      -DBUILD_WEBSOCKET_OPCODE=ON
      -DBUILD_WIIMOTE_OPCODES=ON
      -DCSOUND_LIBRARY=7.0
      -DPLUGIN_INSTALL_DIR=#{install_dir}
      -DPython3_EXECUTABLE=#{which("python3.15")}
    ]
    args += if OS.mac?
      csound_framework = Formula["csound"].opt_frameworks/"CsoundLib64.framework"
      %W[
        -DBUILD_P5GLOVE_OPCODES=ON
        -DP5GLOVE_USE_BUNDLED=ON
        -DCSOUND_FRAMEWORK=#{csound_framework}
        -DCSOUND_INCLUDE_DIR=#{csound_framework}/Headers
      ]
    else
      %w[-DBUILD_P5GLOVE_OPCODES=OFF]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.orc").write <<~ORC
      0dbfs = 1
      gi_programHandle faustcompile "process = _;", "--vectorize --loop-variant 1"
      gi_fluidEngineNumber fluidEngine
      gi_realVector la_i_vr_create 1
      pyinit
      instr 1
          a_signal STKPlucked 440, 1
          a_, a_ hrtfstat a_signal, 0, 0, sprintf("hrtf-%d-left.dat", sr), sprintf("hrtf-%d-right.dat", sr), 9, sr
          hdf5write "test.h5", a_signal
          out a_signal
      endin
    ORC

    (testpath/"test.sco").write <<~SCO
      i 1 0 1
      e
    SCO

    csound = Formula["csound"]
    ENV["SADIR"] = if OS.mac?
      csound.opt_frameworks/"CsoundLib64.framework/Versions/Current/samples"
    else
      csound.opt_share/"samples"
    end
    ENV["RAWWAVE_PATH"] = Formula["stk"].opt_pkgshare/"rawwaves"

    system csound.opt_bin/"csound", "test.orc", "test.sco"

    assert_path_exists testpath/"test.#{OS.mac? ? "aif" : "wav"}"
    assert_path_exists testpath/"test.h5"

    (testpath/"opcode-existence.orc").write <<~ORC
      instr 1
          i_ websocket 8888, 0
          i_ wiiconnect 1, 1
          #{"p5gconnect" if OS.mac?}
      endin
    ORC
    system csound.opt_bin/"csound", "--orc", "--syntax-check-only", "opcode-existence.orc"
  end
end
