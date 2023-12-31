class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "7196e979a0449ce28afd46a78383476f3b8fc1cc1d3a417192be439ede83437b"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8db69f0e0ada2620378e51662bc354e7d8945581cd7b834041c6cc7f7b98efb0"
    sha256 cellar: :any,                 arm64_ventura:  "8e320fd85149a34410212a7185e1f5eef88fe4bbd06c9c46a52bb4c874927961"
    sha256 cellar: :any,                 arm64_monterey: "5d7373a09f160aa2add924d60b192e4eaa133ae701254b7e73a78ebc5661e599"
    sha256 cellar: :any,                 sonoma:         "7a3581a0ac83f353d591f72353f164b6362e3d8dd14688aad98329a308bd6f0a"
    sha256 cellar: :any,                 ventura:        "1ece7fc2a9704c19850f5198891822c7355a18762f4a4a1e418f29be50027126"
    sha256 cellar: :any,                 monterey:       "ebbf0fa7efc34488dd6d2493bf6fa7a10b9ef669858acd0f8352ab9355aec657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bbf20c67aabcdeb4f4786f2fdd3a4a5c7326d584b0dff9355a3540e873e242a"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "imath"
  depends_on "little-cms2"
  depends_on "minizip-ng"
  depends_on "openexr"
  depends_on "pystring"
  depends_on "python@3.12"
  depends_on "yaml-cpp"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def python3
    "python3.12"
  end

  # upstream issue report, https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1920
  patch :DATA

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DOCIO_BUILD_GPU_TESTS=OFF
      -DOCIO_BUILD_TESTS=OFF
      -DOCIO_INSTALL_EXT_PACKAGES=NONE
      -DOCIO_PYTHON_VERSION=#{Language::Python.major_minor_version python3}
      -DPython_EXECUTABLE=#{which(python3)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:
        #{HOMEBREW_PREFIX}/share/ocio/setup_ocio.sh

      Alternatively the documentation describes what env-variables need set:
        https://opencolorio.org/installation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:
        https://opencolorio.org/downloads.html
    EOS
  end

  test do
    assert_match "validate", shell_output("#{bin}/ociocheck --help", 1)
    system python3, "-c", "import PyOpenColorIO as OCIO; print(OCIO.GetCurrentConfig())"
  end
end

__END__
diff --git a/src/OpenColorIO/ConfigUtils.cpp b/src/OpenColorIO/ConfigUtils.cpp
index 2e77472..b4228ff 100644
--- a/src/OpenColorIO/ConfigUtils.cpp
+++ b/src/OpenColorIO/ConfigUtils.cpp
@@ -3,7 +3,7 @@

 #include "ConfigUtils.h"
 #include "MathUtils.h"
-#include "pystring/pystring.h"
+#include "pystring.h"
 #include "utils/StringUtils.h"

 namespace OCIO_NAMESPACE
