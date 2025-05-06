class Ibex < Formula
  desc "C++ library for constraint processing over real numbers"
  homepage "https://ibex-team.github.io/ibex-lib/"
  url "https://github.com/ibex-team/ibex-lib/archive/refs/tags/ibex-2.9.0.tar.gz"
  sha256 "8d16ac2dfbc6de0353a12b7008d1d566bda52178f247d8461be02063972311a6"
  license "LGPL-3.0-only"
  head "https://github.com/ibex-team/ibex-lib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^ibex[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "81f2219bb5ace8fd196334c02cc5be36d3c708a21b778138cc89f49d48c5f11e"
    sha256 cellar: :any,                 arm64_sonoma:  "c1aa3a31657f99acd38c81e90595f4bd9b34710ef22482a22cd4a44e9f1c1cf4"
    sha256 cellar: :any,                 arm64_ventura: "e7337ed741f758908a333c04e29aecf4c6a36888cc99682766e1c34b2ab61719"
    sha256 cellar: :any,                 sonoma:        "b38534dba34ff9bddf80c2e0c3ee09c3312e5e92cd28f6590af0cd6cd363d341"
    sha256 cellar: :any,                 ventura:       "8f57286a04f31143a67d3cd7d58c70fda908f5a2dbcc00a7589821f1f29ff1c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e660a514b4bc69bcb13000715af40d392fa65b5daac014401d46a1482370f661"
  end

  depends_on "bison" => :build
  depends_on "cmake" => [:build, :test]
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "zlib"

  on_linux do
    # https://github.com/ibex-team/ibex-lib/blob/master/interval_lib_wrapper/gaol/3rd/mathlib-2.1.1/CMakeLists.txt
    depends_on arch: :x86_64
  end

  # Workaround for Intel macOS processor detection
  # Issue ref: https://github.com/ibex-team/ibex-lib/issues/567
  patch :DATA

  def install
    rpaths = [loader_path, rpath, rpath(target: lib/"ibex/3rd")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    *std_cmake_args.reject { |s| s["CMAKE_INSTALL_LIBDIR"] }

    # Workaround for Intel macOS build error: no member named '__fpcr' in 'fenv_t'
    # Issue ref: https://github.com/ibex-team/ibex-lib/issues/567
    if OS.mac? && Hardware::CPU.intel?
      inreplace "build/interval_lib_wrapper/gaol/gaol-4.2.3alpha0/gaol/gaol_fpu_fenv.h",
                "#if __APPLE__\n#   define CTRLWORD(v) (v).__fpcr",
                "#if __APPLE__\n#   define CTRLWORD(v) (v).__control"
    end

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install %w[examples benchs/solver]
    (pkgshare/"examples/symb01.txt").write <<~EOS
      function f(x)
        return ((2*x,-x);(-x,3*x));
      end
    EOS
  end

  test do
    system "cmake", "-S", pkgshare/"examples", "-B", ".", "-DCMAKE_BUILD_RPATH=#{lib};#{lib}/ibex/3rd"
    system "cmake", "--build", "."
    (1..8).each { |n| system "./lab#{n}" }
    (1..3).each { |n| system "./slam#{n}" }
  end
end

__END__
diff --git a/interval_lib_wrapper/gaol/3rd/mathlib-2.1.1/CMakeLists.txt b/interval_lib_wrapper/gaol/3rd/mathlib-2.1.1/CMakeLists.txt
index 65b5ea8b..24a2e5b9 100644
--- a/interval_lib_wrapper/gaol/3rd/mathlib-2.1.1/CMakeLists.txt
+++ b/interval_lib_wrapper/gaol/3rd/mathlib-2.1.1/CMakeLists.txt
@@ -43,7 +43,7 @@ elseif (CMAKE_SYSTEM MATCHES "CYGWIN" AND CMAKE_SYSTEM_PROCESSOR MATCHES "i.86")
 elseif (CMAKE_SYSTEM MATCHES "Darwin")
   if (CMAKE_SYSTEM_PROCESSOR MATCHES "arm64")
     set (MATHLIB_AARCH64 ON)
-  elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "i.86")
+  elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "i.86|86_64")
     set (MATHLIB_I86_MACOSX ON)
     set (IX86_CPU ON)
   else ()
