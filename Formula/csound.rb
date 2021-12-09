class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound.git",
      tag:      "6.16.2",
      revision: "fb5bdb3681e15f56c216b4e4487b45848aa6b9f4"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/csound/csound.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "cf2b0001027c56702ec47c6b19f7f08bd1d175b50905ff7307777625664e4dfd"
    sha256 arm64_big_sur:  "5f72a25d33034fd86e8de8526b50e64aa06e98dbb07f2ad0474de315aa6273ef"
    sha256 monterey:       "c03ef7b909f6e843cd133f601e0f8d6f23a2a83dd860923c016a28003caf7bdf"
    sha256 big_sur:        "09d0bf7e5dcc8475ea662db2b148055aacdd8fd25544203bfdd7ce55b5dae02b"
    sha256 catalina:       "31662f37b880f71f7b050c2abe40f2e14a64523e560947919620ebe334bec32d"
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
  depends_on "liblo"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "libsndfile"
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
    url "https://github.com/Ableton/link/archive/Link-3.0.3.tar.gz"
    sha256 "195b46f7a33bb88800de19bb08065ec0235e5a920d203a4b2c644c18fbcaff11"
  end

  resource "csound-plugins" do
    url "https://github.com/csound/plugins/archive/63b784625e66109babd3b669abcb55f5b404f976.tar.gz"
    sha256 "c4ae6754990ae7caf5b7f4e8f3c11f2323379d576a0e4cb10185b4d6d688ed41"
  end

  resource "getfem" do
    url "https://download.savannah.gnu.org/releases/getfem/stable/getfem-5.4.1.tar.gz"
    sha256 "6b58cc960634d0ecf17679ba12f8e8cfe4e36b25a5fa821925d55c42ff38a64e"
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].libexec/"openjdk.jdk/Contents/Home"

    resource("getfem").stage { cp_r "src/gmm", buildpath }

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_JAVA_INTERFACE=ON",
                    "-DBUILD_LINEAR_ALGEBRA_OPCODES=ON",
                    "-DBUILD_LUA_INTERFACE=OFF",
                    "-DBUILD_WEBSOCKET_OPCODE=OFF",
                    "-DCMAKE_INSTALL_RPATH=@loader_path/../Frameworks;#{rpath}",
                    "-DCS_FRAMEWORK_DEST=#{frameworks}",
                    "-DGMM_INCLUDE_DIR=#{buildpath}/gmm",
                    "-DJAVA_MODULE_INSTALL_DIR=#{libexec}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    include.install_symlink frameworks/"CsoundLib64.framework/Headers" => "csound"

    libexec.install buildpath/"interfaces/ctcsound.py"

    (prefix/Language::Python.site_packages("python3")/"homebrew-csound.pth").write <<~EOS
      import site; site.addsitedir('#{libexec}')
    EOS

    resource("ableton-link").stage buildpath/"ableton-link"

    resource("csound-plugins").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DABLETON_LINK_HOME=#{buildpath}/ableton-link",
                      "-DBUILD_ABLETON_LINK_OPCODES=ON",
                      "-DBUILD_CHUA_OPCODES=OFF",
                      "-DCSOUNDLIB=CsoundLib64",
                      "-DCSOUND_INCLUDE_DIR=#{include}/csound",
                      "-DCS_FRAMEWORK_DEST=#{frameworks}",
                      "-DUSE_FLTK=OFF",
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

    output = shell_output "#{bin}/csound test.orc test.sco 2>&1"
    assert_match(/^rtaudio:/, output)
    assert_match(/^rtmidi:/, output)

    assert_predicate testpath/"test.aif", :exist?
    assert_predicate testpath/"test.h5", :exist?

    (testpath/"opcode-existence.orc").write <<~EOS
      JackoInfo
      instr 1
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
