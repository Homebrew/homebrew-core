class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  url "https://download.kde.org/stable/clazy/1.12/src/clazy-1.12.tar.xz"
  sha256 "611749141d07ce1e006f8a1253f9b2dbd5b7b44d2d5322d471d62430ec2849ac"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fc1764ea6472e02a49f65ea8b84b7e804fde9e1ac93068e4ecaa899e04c0700d"
    sha256 cellar: :any,                 arm64_ventura:  "4b099260bc2cc27fb8d2ffd6076d0b4669fdb60de681008d532165e99944b115"
    sha256 cellar: :any,                 arm64_monterey: "718d6f9641dcf3ec83a209dae25f5ecd92bb9f457683ebe78eb6a343e764e6d9"
    sha256 cellar: :any,                 sonoma:         "7b2be755cf6e8aece62b91278a39cd9a4a212f2cf522a0a85a8ab15ef13e376c"
    sha256 cellar: :any,                 ventura:        "0bb9b8009089e1008f032d161ea020fb063b0bce5efc8547403c0d0bbc63ca17"
    sha256 cellar: :any,                 monterey:       "5e579784f42382d246f33932a3a234246240b21f9aa1d4cf5a68ca0c761c3814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e20abd041669c16180b468c6b40df869dae2d6457eddd6aa781bb645b5d66b3e"
  end

  depends_on "cmake"   => [:build, :test]
  depends_on "qt"      => :test
  depends_on "coreutils"
  # TODO: Backport patch for LLVM 18 support
  # https://github.com/KDE/clazy/commit/be6ec9a3f3e1e4cb7168845008fd4d0593877b64
  depends_on "llvm@17"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5" # C++17

  def install
    ENV.append "CXXFLAGS", "-std=gnu++17" # Fix `std::regex` support detection.
    system "cmake", "-S", ".", "-B", "build", "-DCLAZY_LINK_CLANG_DYLIB=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Core REQUIRED)

      add_executable(test
          test.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core
      )
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <QtCore/QString>
      void test()
      {
          qgetenv("Foo").isEmpty();
      }
      int main() { return 0; }
    EOS

    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    ENV["CLANGXX"] = llvm.opt_bin/"clang++"
    system "cmake", "-DCMAKE_CXX_COMPILER=#{bin}/clazy", "."
    assert_match "warning: qgetenv().isEmpty() allocates. Use qEnvironmentVariableIsEmpty() instead",
      shell_output("make VERBOSE=1 2>&1")
  end
end

__END__
diff --git a/src/checks/manuallevel/unexpected-flag-enumerator-value.cpp b/src/checks/manuallevel/unexpected-flag-enumerator-value.cpp
index ae1e607..f20c42d 100644
--- a/src/checks/manuallevel/unexpected-flag-enumerator-value.cpp
+++ b/src/checks/manuallevel/unexpected-flag-enumerator-value.cpp
@@ -58,11 +58,13 @@ static bool isIntentionallyNotPowerOf2(EnumConstantDecl *en) {
     constexpr unsigned MinOnesToQualifyAsMask = 3;

     const auto val = en->getInitVal();
-    if (val.isMask() && val.countTrailingOnes() >= MinOnesToQualifyAsMask)
+    if (val.isMask() && val.countTrailingOnes() >= MinOnesToQualifyAsMask) {
         return true;
+    }

-    if (val.isShiftedMask() && val.countPopulation() >= MinOnesToQualifyAsMask)
+    if (val.isShiftedMask() && val.countPopulation() >= MinOnesToQualifyAsMask) {
         return true;
+    }

     if (clazy::contains_lower(en->getName(), "mask"))
         return true;
@@ -159,8 +161,9 @@ void UnexpectedFlagEnumeratorValue::VisitDecl(clang::Decl *decl)
     for (EnumConstantDecl* enumerator : enumerators) {
         const auto &initVal = enumerator->getInitVal();
         if (!initVal.isPowerOf2() && !initVal.isNullValue() && !initVal.isNegative()) {
-            if (isIntentionallyNotPowerOf2(enumerator))
+            if (isIntentionallyNotPowerOf2(enumerator)) {
                 continue;
+            }
             const auto value = enumerator->getInitVal().getLimitedValue();
             Expr *initExpr = enumerator->getInitExpr();
             emitWarning(initExpr ? initExpr->getBeginLoc() : enumerator->getBeginLoc(), "Unexpected non power-of-2 enumerator value: " + std::to_string(value));
