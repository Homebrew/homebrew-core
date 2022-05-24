class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound.git",
      tag:      "6.17.0",
      revision: "f5b4258794a82c99f7d85f1807c6638f2e80ccac"
  license "LGPL-2.1-or-later"
  revision 5
  head "https://github.com/csound/csound.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "1175c3fceb71974686a1ca92dd0ba221cbe77bcd46ea114b872b5fbf545d51e9"
    sha256 arm64_big_sur:  "08207e1b01164ee73f5570933b4522943319277074ba1f4836bbab741bf96a3a"
    sha256 monterey:       "78443a71a60eebea86219a5bfd612dc2b9fb6d4c70621b4ae83fc192e42b462a"
    sha256 big_sur:        "8b5d329857d11f3cd4fb193c212d112d16dd328433ae6dd4c7a0218822b06ec3"
    sha256 catalina:       "0b953aee205007ead4e9e69a2bbcb572b5f2d3fbf1b22e8539ca007c8628dab1"
    sha256 x86_64_linux:   "d4bd60ac72dd39fbe4c20833d2455aeda2ef701d7fe82c4acda7dec079ee1aa5"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "swig" => :build
  depends_on "faust"
  depends_on "fltk"
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
  depends_on "numpy"
  depends_on "openjdk"
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "python@3.9"
  depends_on "stk"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "wiiuse"
  end

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "libextractor", because: "both install `extract` binaries"
  conflicts_with "pkcrack", because: "both install `extract` binaries"

  fails_with gcc: "5"

  resource "ableton-link" do
    url "https://github.com/Ableton/link/archive/Link-3.0.5.tar.gz"
    sha256 "74a470c8ae8f9c325e65e981839852e821ec56b980f8b923cb77ca833c4603ed"
  end

  resource "csound-plugins" do
    url "https://github.com/csound/plugins/archive/refs/tags/1.0.2.tar.gz"
    sha256 "8c2f0625ad1d38400030f414b92d82cfdec5c04b7dc178852f3e1935abf75d30"

    # Fix build on macOS 12.3+ by replacing old system Python/Python.h with Homebrew's Python.h
    patch do
      url "https://github.com/csound/plugins/commit/13800c4dd58e3c214e5d7207180ad7115b4e2f27.patch?full_index=1"
      sha256 "e088cc300845408f3956f070fa34a900b700c7860678bc6d37f7506d615787a6"
    end
  end

  resource "getfem" do
    url "https://download.savannah.gnu.org/releases/getfem/stable/getfem-5.4.1.tar.gz"
    sha256 "6b58cc960634d0ecf17679ba12f8e8cfe4e36b25a5fa821925d55c42ff38a64e"
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    args = [
      "-DBUILD_JAVA_INTERFACE=ON",
      "-DBUILD_LUA_INTERFACE=OFF",
      "-DCS_FRAMEWORK_DEST=#{frameworks}",
      "-DJAVA_MODULE_INSTALL_DIR=#{libexec}",
    ]
    args << "-DCMAKE_INSTALL_RPATH=@loader_path/../Frameworks;#{rpath}" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # On Linux, csound depends on binutils, but both formulae install `srconv` binaries
    rm_f bin/"srconv" if OS.linux?

    include.install_symlink frameworks/"CsoundLib64.framework/Headers" => "csound" if OS.mac?

    libexec.install buildpath/"interfaces/ctcsound.py"

    (prefix/Language::Python.site_packages("python3")/"homebrew-csound.pth").write <<~EOS
      import site; site.addsitedir('#{libexec}')
    EOS

    resource("csound-plugins").stage do
      resource("ableton-link").stage buildpath/"ableton-link"
      resource("getfem").stage { cp_r "src/gmm", buildpath }

      args = [
        "-DABLETON_LINK_HOME=#{buildpath}/ableton-link",
        "-DBUILD_ABLETON_LINK_OPCODES=ON",
        "-DBUILD_CHUA_OPCODES=ON",
        "-DBUILD_CUDA_OPCODES=OFF",
        "-DBUILD_FAUST_OPCODES=ON",
        "-DBUILD_FLUID_OPCODES=ON",
        "-DBUILD_HDF5_OPCODES=ON",
        "-DBUILD_IMAGE_OPCODES=ON",
        "-DBUILD_JACK_OPCODES=ON",
        "-DBUILD_LINEAR_ALGEBRA_OPCODES=ON",
        "-DBUILD_MP3OUT_OPCODE=ON",
        "-DBUILD_OPENCL_OPCODES=OFF",
        "-DBUILD_PYTHON_OPCODES=ON",
        "-DBUILD_STK_OPCODES=ON",
        "-DBUILD_WEBSOCKET_OPCODE=ON",
        "-DGMM_INCLUDE_DIR=#{buildpath}",
        "-DUSE_FLTK=ON",
      ]
      if OS.mac?
        args << "-DBUILD_P5GLOVE_OPCODES=ON"
        args << "-DBUILD_WIIMOTE_OPCODES=ON"
        args << "-DCSOUND_FRAMEWORK=#{frameworks}/CsoundLib64.framework"
        args << "-DCSOUND_INCLUDE_DIR=#{include}/csound"
        args << "-DPLUGIN_INSTALL_DIR=#{frameworks}/CsoundLib64.framework/Resources/Opcodes64"
      else
        args << "-DBUILD_P5GLOVE_OPCODES=OFF"
        args << "-DBUILD_WIIMOTE_OPCODES=OFF"
      end
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  def caveats
    caveats = <<~EOS
      To use the Java bindings, you may need to add to #{shell_profile}:
        export CLASSPATH="#{opt_libexec}/csnd6.jar:."
      and link the native shared library into your Java Extensions folder:
    EOS

    on_macos do
      caveats = <<~EOS
        #{caveats}\
          mkdir -p ~/Library/Java/Extensions
          ln -s "#{opt_libexec}/lib_jcsound6.jnilib" ~/Library/Java/Extensions
      EOS
    end

    on_linux do
      caveats = <<~EOS
        srconv is not installed because it conflicts with binutils. To run srconv:
          csound --utility=srconv

        #{caveats}\
          sudo mkdir -p /usr/java/packages/lib
          sudo ln -s "#{opt_libexec}/lib_jcsound6.jnilib" /usr/java/packages/lib
      EOS
    end

    caveats
  end

  test do
    (testpath/"test.orc").write <<~EOS
      0dbfs = 1
      gi_peer link_create
      gi_programHandle faustcompile "process = _;", "--vectorize --loop-variant 1"
      FLrun
      gi_fluidEngineNumber fluidEngine
      gi_realVector la_i_vr_create 1
      pyinit
      instr 1
          a_, a_, a_ chuap 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          a_signal STKPlucked 440, 1
          a_, a_ hrtfstat a_signal, 0, 0, sprintf("hrtf-%d-left.dat", sr), sprintf("hrtf-%d-right.dat", sr), 9, sr
          hdf5write "test.h5", a_signal
          mp3out a_signal, a_signal, "test.mp3"
          out a_signal
      endin
    EOS

    (testpath/"test.sco").write <<~EOS
      i 1 0 1
      e
    EOS

    if OS.mac?
      ENV["OPCODE6DIR64"] = frameworks/"CsoundLib64.framework/Resources/Opcodes64"
      ENV["SADIR"] = frameworks/"CsoundLib64.framework/Versions/Current/samples"
    else
      ENV["OPCODE6DIR64"] = lib/"csound/plugins64-6.0"
      ENV["SADIR"] = share/"samples"
    end
    ENV["RAWWAVE_PATH"] = Formula["stk"].pkgshare/"rawwaves"

    system bin/"csound", "test.orc", "test.sco"

    assert_predicate testpath/"test.#{OS.mac? ? "aif" : "wav"}", :exist?
    assert_predicate testpath/"test.h5", :exist?
    assert_predicate testpath/"test.mp3", :exist?

    (testpath/"opcode-existence.orc").write <<~EOS
      JackoInfo
      instr 1
          i_ websocket 8888, 0
      endin
    EOS
    system bin/"csound", "--orc", "--syntax-check-only", "opcode-existence.orc"

    if OS.mac?
      (testpath/"mac-opcode-existence.orc").write <<~EOS
        instr 1
            p5gconnect
            i_ wiiconnect 1, 1
        endin
      EOS
      system bin/"csound", "--orc", "--syntax-check-only", "mac-opcode-existence.orc"
    end

    system Formula["python@3.9"].bin/"python3", "-c", "import ctcsound"

    (testpath/"test.java").write <<~EOS
      import csnd6.*;
      public class test {
          public static void main(String args[]) {
              csnd6.csoundInitialize(csnd6.CSOUNDINIT_NO_ATEXIT | csnd6.CSOUNDINIT_NO_SIGNAL_HANDLER);
          }
      }
    EOS
    system Formula["openjdk"].bin/"javac", "-classpath", "#{libexec}/csnd6.jar", "test.java"
    system Formula["openjdk"].bin/"java", "-classpath", "#{libexec}/csnd6.jar:.",
                                          "-Djava.library.path=#{libexec}", "test"
  end
end
