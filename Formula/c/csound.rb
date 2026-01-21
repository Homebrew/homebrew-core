class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  license "LGPL-2.1-or-later"
  revision 13
  head "https://github.com/csound/csound.git", branch: "develop"

  # Remove `stable` block when patches are no longer needed
  stable do
    url "https://github.com/csound/csound.git",
        tag:      "6.18.1",
        revision: "a1580f9cdf331c35dceb486f4231871ce0b00266"

    # Fix build failure due to mismatched pointer types on macOS 14+
    patch do
      url "https://github.com/csound/csound/commit/596667daba1ed99eda048e491ff8f36200f09429.patch?full_index=1"
      sha256 "ab6d09d1a2cede584e151b514fc4cff56b88f79008e725c3a76df64b59caf866"
    end

    patch do
      url "https://github.com/csound/csound/commit/2a071ae8ca89bc21b5c80037f8c95a01bb670ac9.patch?full_index=1"
      sha256 "c7026330b5c89ab399e74aff17019067705011b7e35b9c75f9ed1a5878f53b4b"
    end

    # Fix build failure due to incorrect member name on macOS 15+
    patch do
      url "https://github.com/csound/csound/commit/bb9bafcfa17a87d3733eda1e25a812fd0be08ac6.patch?full_index=1"
      sha256 "b1492e344a7cc067989ef600a08319d388bebb344fee616d83dce969f3afe8cb"
    end
  end

  # Latest version is in beta, e.g. 7.0.0-beta.10
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "1358e7d52d01425eb57d9315f6660ce5c753c4bd6406f1a82fe8b7f3c0645618"
    sha256 arm64_sequoia: "cd3cceb2b0a1d0556f29d7d71e1aee94a289f61ba25790f9d3f50420502332e1"
    sha256 arm64_sonoma:  "1c33262915a2133bd0f08611de8aa60326142b12ca81834bd926fa9af2820a77"
    sha256 sonoma:        "52d703b25a4e5ccd9e83cbd68ee8ba290c7da2d4ba41371c07c287dcb2abdcf3"
    sha256 arm64_linux:   "38cc39a0d24c0d44b6f0393b29a49409c728a3c3ecfcce8a7f0e2ec3640a06d8"
    sha256 x86_64_linux:  "edd32b95ddd140f4395155849cd24344489991ee377526b80f8e7a9a3b117204"
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
  depends_on "openssl@3"
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "python@3.14"
  depends_on "stk"
  depends_on "wiiuse"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
  end

  conflicts_with "libextractor", because: "both install `extract` binaries"

  resource "ableton-link" do
    url "https://github.com/Ableton/link/archive/refs/tags/Link-3.1.3.tar.gz"
    sha256 "b0eba86d40a46b01ab821cdfb53041bfc693f0266538ea8163f1cea7ac42f476"
  end

  resource "csound-plugins" do
    url "https://github.com/csound/plugins/archive/refs/tags/1.0.2.tar.gz"
    sha256 "8c2f0625ad1d38400030f414b92d82cfdec5c04b7dc178852f3e1935abf75d30"

    # Fix build on macOS 12.3+ by replacing old system Python/Python.h with Homebrew's Python.h
    patch do
      url "https://github.com/csound/plugins/commit/13800c4dd58e3c214e5d7207180ad7115b4e2f27.patch?full_index=1"
      sha256 "e088cc300845408f3956f070fa34a900b700c7860678bc6d37f7506d615787a6"
    end

    # Fix Eigen detection to work with Homebrew's Eigen formula
    patch :DATA
  end

  resource "getfem" do
    url "https://download.savannah.gnu.org/releases/getfem/stable/getfem-5.4.2.tar.gz"
    sha256 "80b625d5892fe9959c3b316340f326e3ece4e98325eb0a81dd5b9ddae563b1d1"
  end

  def python3
    which("python3.14")
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    site_packages = prefix/Language::Python.site_packages(python3)
    rpaths = [rpath]
    rpaths << rpath(target: frameworks) if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DBUILD_JAVA_INTERFACE=ON",
                    "-DBUILD_LUA_INTERFACE=OFF",
                    "-DBUILD_TESTS=OFF",
                    "-DCS_FRAMEWORK_DEST=#{frameworks}",
                    "-DJAVA_MODULE_INSTALL_DIR=#{libexec}",
                    "-DPYTHON3_MODULE_INSTALL_DIR=#{site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      include.install_symlink frameworks/"CsoundLib64.framework/Headers" => "csound"
      site_packages.install buildpath/"interfaces/ctcsound.py"
    else
      # On Linux, csound depends on binutils, but both formulae install `srconv` binaries
      (bin/"srconv").unlink
    end

    resource("csound-plugins").stage do
      resource("ableton-link").stage buildpath/"ableton-link"
      resource("getfem").stage { cp_r "src/gmm", buildpath }

      # Can remove minimum policy in a release with
      # https://github.com/csound/plugins/commit/0a95ad72b5eb0a81bc680c2ac04da9a7c220715b
      args = %W[
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        -DCMAKE_CXX_STANDARD=17
        -DABLETON_LINK_HOME=#{buildpath}/ableton-link
        -DBUILD_ABLETON_LINK_OPCODES=ON
        -DBUILD_CHUA_OPCODES=ON
        -DBUILD_CUDA_OPCODES=OFF
        -DBUILD_FAUST_OPCODES=ON
        -DBUILD_FLUID_OPCODES=ON
        -DBUILD_HDF5_OPCODES=ON
        -DBUILD_IMAGE_OPCODES=ON
        -DBUILD_JACK_OPCODES=ON
        -DBUILD_LINEAR_ALGEBRA_OPCODES=ON
        -DBUILD_MP3OUT_OPCODE=ON
        -DBUILD_OPENCL_OPCODES=OFF
        -DBUILD_PYTHON_OPCODES=ON
        -DBUILD_STK_OPCODES=ON
        -DBUILD_WEBSOCKET_OPCODE=ON
        -DBUILD_WIIMOTE_OPCODES=ON
        -DGMM_INCLUDE_DIR=#{buildpath}
        -DPython3_EXECUTABLE=#{python3}
        -DUSE_FLTK=ON
      ]
      args += if OS.mac?
        %W[
          -DBUILD_P5GLOVE_OPCODES=ON
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
    caveats = <<~EOS
      To use the Java bindings, you may need to add to your shell profile
      e.g. ~/.profile or ~/.zshrc:
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
    (testpath/"test.orc").write <<~ORC
      0dbfs = 1
      gi_peer link_create
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
    ORC

    (testpath/"test.sco").write <<~SCO
      i 1 0 1
      e
    SCO

    if OS.mac?
      ENV["OPCODE6DIR64"] = frameworks/"CsoundLib64.framework/Resources/Opcodes64"
      ENV["SADIR"] = frameworks/"CsoundLib64.framework/Versions/Current/samples"
    else
      ENV["OPCODE6DIR64"] = lib/"csound/plugins64-6.0"
      ENV["SADIR"] = share/"samples"
    end
    ENV["RAWWAVE_PATH"] = Formula["stk"].pkgshare/"rawwaves"

    system bin/"csound", "test.orc", "test.sco"

    assert_path_exists testpath/"test.#{OS.mac? ? "aif" : "wav"}"
    assert_path_exists testpath/"test.h5"
    assert_path_exists testpath/"test.mp3"

    (testpath/"opcode-existence.orc").write <<~ORC
      gi_programHandle faustcompile "process = _;", "--vectorize --loop-variant 1"
      JackoInfo
      instr 1
          i_ websocket 8888, 0
          i_ wiiconnect 1, 1
      endin
    ORC
    system bin/"csound", "--orc", "--syntax-check-only", "opcode-existence.orc"

    if OS.mac?
      (testpath/"mac-opcode-existence.orc").write <<~ORC
        instr 1
            p5gconnect
        endin
      ORC
      system bin/"csound", "--orc", "--syntax-check-only", "mac-opcode-existence.orc"
    end

    system python3, "-c", "import ctcsound"

    (testpath/"test.java").write <<~JAVA
      import csnd6.*;
      public class test {
          public static void main(String args[]) {
              csnd6.csoundInitialize(csnd6.CSOUNDINIT_NO_ATEXIT | csnd6.CSOUNDINIT_NO_SIGNAL_HANDLER);
          }
      }
    JAVA
    system Formula["openjdk"].bin/"javac", "-classpath", "#{libexec}/csnd6.jar", "test.java"
    system Formula["openjdk"].bin/"java", "-classpath", "#{libexec}/csnd6.jar:.",
                                          "-Djava.library.path=#{libexec}", "test"
  end
end

__END__
diff --git a/cmake/Modules/FindEIGEN3.cmake b/cmake/Modules/FindEIGEN3.cmake
index 9eec7b4..40c3af0 100644
--- a/cmake/Modules/FindEIGEN3.cmake
+++ b/cmake/Modules/FindEIGEN3.cmake
@@ -36,27 +36,8 @@ if(NOT Eigen3_FIND_VERSION)
 endif(NOT Eigen3_FIND_VERSION)
 
 macro(_eigen3_check_version)
-  file(READ "${EIGEN3_INCLUDE_DIR}/Eigen/src/Core/util/Macros.h" _eigen3_version_header)
-
-  string(REGEX MATCH "define[ \t]+EIGEN_WORLD_VERSION[ \t]+([0-9]+)" _eigen3_world_version_match "${_eigen3_version_header}")
-  set(EIGEN3_WORLD_VERSION "${CMAKE_MATCH_1}")
-  string(REGEX MATCH "define[ \t]+EIGEN_MAJOR_VERSION[ \t]+([0-9]+)" _eigen3_major_version_match "${_eigen3_version_header}")
-  set(EIGEN3_MAJOR_VERSION "${CMAKE_MATCH_1}")
-  string(REGEX MATCH "define[ \t]+EIGEN_MINOR_VERSION[ \t]+([0-9]+)" _eigen3_minor_version_match "${_eigen3_version_header}")
-  set(EIGEN3_MINOR_VERSION "${CMAKE_MATCH_1}")
-
-  set(EIGEN3_VERSION ${EIGEN3_WORLD_VERSION}.${EIGEN3_MAJOR_VERSION}.${EIGEN3_MINOR_VERSION})
-  if(${EIGEN3_VERSION} VERSION_LESS ${Eigen3_FIND_VERSION})
-    set(EIGEN3_VERSION_OK FALSE)
-  else(${EIGEN3_VERSION} VERSION_LESS ${Eigen3_FIND_VERSION})
-    set(EIGEN3_VERSION_OK TRUE)
-  endif(${EIGEN3_VERSION} VERSION_LESS ${Eigen3_FIND_VERSION})
-
-  if(NOT EIGEN3_VERSION_OK)
-
-    message(STATUS "Eigen3 version ${EIGEN3_VERSION} found in ${EIGEN3_INCLUDE_DIR}, "
-                   "but at least version ${Eigen3_FIND_VERSION} is required")
-  endif(NOT EIGEN3_VERSION_OK)
+  set(EIGEN3_VERSION "5.0.1")
+  set(EIGEN3_VERSION_OK TRUE)
 endmacro(_eigen3_check_version)
 
 if (EIGEN3_INCLUDE_DIR)
