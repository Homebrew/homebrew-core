class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound.git",
      tag:      "7.0.0",
      revision: "c58f4de6b8056b9356f31615b395b3bfd9bd0775"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/csound/csound.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_golden_gate: "4eeb66353b17e65389ad1655d838f4d27e7efdd2eb68af8ecf488c835d7ddc4b"
    sha256 arm64_tahoe:       "837bea4f223728b672dfe441764fef6f473eb4ecdec6dc386b6d92af5eec44dc"
    sha256 arm64_sequoia:     "067a471c056b0f8104e6e5cd65a7d8afd3b34c9448c14378c9250743e5e3dc5b"
    sha256 arm64_linux:       "da11afcf999246360aeb9dca9f5fe1a82a04254690436b99a71247ce459b8255"
    sha256 x86_64_linux:      "516e75cebba359abab4a8eb002dce0c9f1ad6367ce79f3644651cdc5d92d32b7"
  end

  depends_on "asio" => :build
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "faust"
  depends_on "fluid-synth"
  depends_on "gettext"
  depends_on "hdf5"
  depends_on "jack"
  depends_on "lame"
  depends_on "liblo"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libwebsockets"
  depends_on "openssl@4"
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "python@3.15"
  depends_on "stk"
  depends_on "wiiuse"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "pipewire"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "libextractor", because: "both install `extract` binaries"

  resource "csound-plugins" do
    url "https://github.com/csound/plugins/archive/refs/tags/7.0.0.tar.gz"
    sha256 "5f00ccc3fa28437d2206bbf49136ec0a4fa0f0fd2104f56506232c49219b0df9"

    # Fix non-configurable install location by setting PLUGIN_INSTALL_DIR as a CMake cache entry
    patch do
      url "https://github.com/csound/plugins/commit/94d6dd6feaec8ce1b08fc2f4f21f3e8a9566e4a5.patch?full_index=1"
      sha256 "9c45c643ced98ff3203292b6a534250ceb68d22c695f3ffb56bf58b835746b01"
      type :backport
      resolves "https://github.com/csound/plugins/pull/12"
    end
  end

  def install
    rpaths = [rpath]
    rpaths << rpath(target: frameworks) if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DBISON_EXECUTABLE=#{formula_opt_bin("bison")}/bison",
                    "-DBUILD_TESTS=OFF",
                    "-DCS_FRAMEWORK_DEST=#{frameworks}",
                    "-DINSTALL_PYTHON_INTERFACE=OFF",
                    "-DPython3_EXECUTABLE=#{python3}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      include.install_symlink frameworks/"CsoundLib64.framework/Headers" => "csound"
    else
      # On Linux, csound depends on binutils, but both formulae install `srconv` binaries
      (bin/"srconv").unlink
    end

    resource("csound-plugins").stage do
      args = %w[
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
      ]
      args += if OS.mac?
        %W[
          -DBUILD_P5GLOVE_OPCODES=ON
          -DP5GLOVE_USE_BUNDLED=ON
          -DCSOUND_FRAMEWORK=#{frameworks}/CsoundLib64.framework
          -DCSOUND_INCLUDE_DIR=#{frameworks}/CsoundLib64.framework/Headers
          -DPLUGIN_INSTALL_DIR=#{frameworks}/CsoundLib64.framework/Resources/Opcodes64
        ]
      else
        %w[
          -DBUILD_P5GLOVE_OPCODES=OFF
        ]
      end

      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  def caveats
    on_linux do
      <<~EOS
        srconv is not installed because it conflicts with binutils. To run srconv:
          csound --utility=srconv
      EOS
    end
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

    if OS.mac?
      ENV["OPCODE6DIR64"] = frameworks/"CsoundLib64.framework/Resources/Opcodes64"
      ENV["SADIR"] = frameworks/"CsoundLib64.framework/Versions/Current/samples"
    else
      ENV["OPCODE6DIR64"] = lib/"csound/plugins64-7.0"
      ENV["SADIR"] = share/"samples"
    end
    ENV["RAWWAVE_PATH"] = Formula["stk"].pkgshare/"rawwaves"

    system bin/"csound", "test.orc", "test.sco"

    assert_path_exists testpath/"test.#{OS.mac? ? "aif" : "wav"}"
    assert_path_exists testpath/"test.h5"

    (testpath/"opcode-existence.orc").write <<~ORC
      instr 1
          i_ websocket 8888, 0
          i_ wiiconnect 1, 1
          #{"p5gconnect" if OS.mac?}
      endin
    ORC
    system bin/"csound", "--orc", "--syntax-check-only", "opcode-existence.orc"
  end
end
