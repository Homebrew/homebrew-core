class Ibex < Formula
  desc "C++ library for constraint processing over real numbers"
  homepage "https://ibex-team.github.io/ibex-lib/"
  url "https://github.com/ibex-team/ibex-lib/archive/refs/tags/ibex-2.9.1.tar.gz"
  sha256 "b3cd09c3be137fd2ff0f2570c3bcbdfcd9ea62fcf04d45d058db3b0dbb1d8872"
  license "LGPL-3.0-only"
  head "https://github.com/ibex-team/ibex-lib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^ibex[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "747a401be0719a9769ff455db67125bdb0d964b6652d92a14b5472f1dbe4464e"
    sha256 cellar: :any,                 arm64_sequoia: "47d818bc1c5ab5bf229e05f581dc8ba87cceb42f3681202380cf396041528340"
    sha256 cellar: :any,                 arm64_sonoma:  "eaf0a5af27f495b602478ef2f57b34c32fe661a6822522821ddcf0c7104dcb2f"
    sha256 cellar: :any,                 sonoma:        "67ee5538f5514def4be02292b9907a2cf5085c87fcdcc6ba4394de3cb3339809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07caba7293ca4475838b8a5b89e0d5acda1d5bfcce10ee17ee06f8b7027272d0"
  end

  depends_on "bison" => :build
  depends_on "cmake" => [:build, :test]
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  on_linux do
    # https://github.com/ibex-team/ibex-lib/blob/master/interval_lib_wrapper/gaol/3rd/mathlib-2.1.1/CMakeLists.txt
    depends_on arch: :x86_64
    depends_on "zlib-ng-compat"
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
