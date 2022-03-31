class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound.git",
      tag:      "6.17.0",
      revision: "f5b4258794a82c99f7d85f1807c6638f2e80ccac"
  license "LGPL-2.1-or-later"
  revision 4
  head "https://github.com/csound/csound.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "0102a8b8a2ec2dadee50681fb20cabfa30f33e1b3137f5673501debe7494103e"
    sha256 arm64_big_sur:  "70db4cb2a822e509e04fa53c1491ccc47a42fb2ee47e57c1dcb2845e6d07b42e"
    sha256 monterey:       "cf3f3672accd1ca984719f9ed5160a3e12422a4f92a41c63d25b41149d0b125d"
    sha256 big_sur:        "2a6000b98ac409c6837d1c67e87ec36ce084721d9f4b7df3f365489b20e8346c"
    sha256 catalina:       "dc9686f89a799337f80a0837d076996762c6a3eb2bfea78c8bc74b73b3390cac"
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
  depends_on "wiiuse"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "libextractor", because: "both install `extract` binaries"
  conflicts_with "pkcrack", because: "both install `extract` binaries"

  resource "ableton-link" do
    url "https://github.com/Ableton/link/archive/Link-3.0.4.tar.gz"
    sha256 "c7bb6f75ec805e1314d0181332285c3b3d7a81c9ec7d962b54f727283dac442a"
  end

  resource "csound-plugins" do
    url "https://github.com/csound/plugins/archive/refs/tags/1.0.2.tar.gz"
    sha256 "8c2f0625ad1d38400030f414b92d82cfdec5c04b7dc178852f3e1935abf75d30"
  end

  resource "getfem" do
    url "https://download.savannah.gnu.org/releases/getfem/stable/getfem-5.4.1.tar.gz"
    sha256 "6b58cc960634d0ecf17679ba12f8e8cfe4e36b25a5fa821925d55c42ff38a64e"
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].libexec/"openjdk.jdk/Contents/Home"

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_JAVA_INTERFACE=ON",
                    "-DBUILD_LUA_INTERFACE=OFF",
                    "-DCMAKE_INSTALL_RPATH=@loader_path/../Frameworks;#{rpath}",
                    "-DCS_FRAMEWORK_DEST=#{frameworks}",
                    "-DJAVA_MODULE_INSTALL_DIR=#{libexec}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    include.install_symlink frameworks/"CsoundLib64.framework/Headers" => "csound"

    libexec.install buildpath/"interfaces/ctcsound.py"

    (prefix/Language::Python.site_packages("python3")/"homebrew-csound.pth").write <<~EOS
      import site; site.addsitedir('#{libexec}')
    EOS

    resource("csound-plugins").stage do
      # Fix build on macOS 12.3+ by replacing old system Python/Python.h with Homebrew's Python.h
      # TODO: Remove when fixed upstream.
      inreplace Dir["py/src/{pythonopcodes.c,pythonopcodes.h,pythonhelper.h}"],
                "include <Python/Python.h>",
                "include <Python.h>"

      resource("ableton-link").stage buildpath/"ableton-link"
      resource("getfem").stage { cp_r "src/gmm", buildpath }

      system "cmake", "-S", ".", "-B", "build",
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
                      "-DBUILD_P5GLOVE_OPCODES=ON",
                      "-DBUILD_PYTHON_OPCODES=ON",
                      "-DBUILD_STK_OPCODES=ON",
                      "-DBUILD_WEBSOCKET_OPCODE=ON",
                      "-DBUILD_WIIMOTE_OPCODES=ON",
                      "-DCSOUND_FRAMEWORK=#{frameworks}/CsoundLib64.framework",
                      "-DCSOUND_INCLUDE_DIR=#{include}/csound",
                      "-DGMM_INCLUDE_DIR=#{buildpath}",
                      "-DPLUGIN_INSTALL_DIR=#{frameworks}/CsoundLib64.framework/Resources/Opcodes64",
                      "-DUSE_FLTK=ON",
                      *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  def caveats
    <<~EOS
      To use the Java bindings, you may need to add to #{shell_profile}:
        export CLASSPATH="#{opt_libexec}/csnd6.jar:."
      and link the native shared library into your Java Extensions folder:
        mkdir -p ~/Library/Java/Extensions
        ln -s "#{opt_libexec}/lib_jcsound6.jnilib" ~/Library/Java/Extensions
    EOS
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

    ENV["OPCODE6DIR64"] = frameworks/"CsoundLib64.framework/Resources/Opcodes64"
    ENV["RAWWAVE_PATH"] = Formula["stk"].pkgshare/"rawwaves"
    ENV["SADIR"] = frameworks/"CsoundLib64.framework/Versions/Current/samples"

    system bin/"csound", "test.orc", "test.sco"

    assert_predicate testpath/"test.aif", :exist?
    assert_predicate testpath/"test.h5", :exist?
    assert_predicate testpath/"test.mp3", :exist?

    (testpath/"opcode-existence.orc").write <<~EOS
      JackoInfo
      instr 1
          p5gconnect
          i_output websocket 8888, 0
          i_success wiiconnect 1, 1
      endin
    EOS
    system bin/"csound", "--orc", "--syntax-check-only", "opcode-existence.orc"

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
