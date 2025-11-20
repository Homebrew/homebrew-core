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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f45581909cb2bb4d10fecb82ad0ab195da12a874e2d44e047c1f908cb73aa55d"
    sha256 cellar: :any,                 arm64_sequoia: "dca481e12df41f7d861b7ae1b0a88716e9cac0a46600b51dea4b7a0a1d37034d"
    sha256 cellar: :any,                 arm64_sonoma:  "e41ce1bb4c8e114058faa116a55aba86b39561a7a2d476d754e3313c1d2eca0f"
    sha256 cellar: :any,                 arm64_ventura: "320e1ba86d12bb05b290160e0a383fb235ead88eaec42db08b64e36ea7497902"
    sha256 cellar: :any,                 sonoma:        "62d00c18c11a57cc8acd5afd714f29d321d6c26ec9ee887a63300eb8ef7b4c17"
    sha256 cellar: :any,                 ventura:       "a8b5ba456ba0a05f5d098fd09d4098d9699fe055b3d468739e02c2b5a31e69d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1afc6f3b07d53b149f15451f30b96897b167b157b5f20cec59f56c185bd2d72a"
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
