class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.0.3/qbs-src-3.0.3.tar.gz"
  sha256 "5ea02139263ec4dbf947d18f4a73ccc41f691ec43c5914a6a6b089d9713ec0dc"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only"] },
    { any_of: ["LGPL-3.0-only", "LGPL-2.1-only" => { with: "Qt-LGPL-exception-1.1" }] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
  ]
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea2a3fb3baa67563318e57be8602ce8223cbf2f6f1102556b28600b6fbf872c3"
    sha256 cellar: :any,                 arm64_sequoia: "de23c0f6e1eb0db96bb05300afac1a38edad7ea59860fa94632b8c1380bbcdbc"
    sha256 cellar: :any,                 arm64_sonoma:  "73ed45e1ae002ab27f86d004f7003825478b59726d758996214c24147ce2c387"
    sha256 cellar: :any,                 arm64_ventura: "c04e7d54e0414f6fdea083c401f21fe4d7d7d7a5b00fa163f9180f23a3743972"
    sha256 cellar: :any,                 sonoma:        "e78f408be5a3413cdc154e7a25d00dce596c9eba58cf5188993b16b73e96425b"
    sha256 cellar: :any,                 ventura:       "027a239f45c910ddae143ede13b6117667122eba2979b75c929afbbfcbecda99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a453229b6e2a073c41494aca5077a42207b3a37c1e895187e6e97a9b90465d"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  # Backport support for Xcode 26 from upstream commit:
  # https://github.com/qbs/qbs/commit/2f3e8254573045fab7ebd487aa773527a3da642c
  patch :DATA

  def install
    qt_dir = Formula["qt"].opt_lib/"cmake/Qt6"

    args = %W[
      -DQt6_DIR=#{qt_dir}
      -DQBS_ENABLE_RPATH=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      int main() {
        return 0;
      }
    C

    (testpath/"test.qbs").write <<~QBS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    QBS

    system bin/"qbs", "run", "-f", "test.qbs"
  end
end

__END__
diff --git a/share/qbs/modules/bundle/BundleModule.qbs b/share/qbs/modules/bundle/BundleModule.qbs
index 647663043eb7128249d956fdbc633943739c7be2..518b8a2aac3889816a9c43a1b93aa88eafcff28a 100644
--- a/share/qbs/modules/bundle/BundleModule.qbs
+++ b/share/qbs/modules/bundle/BundleModule.qbs
@@ -93,6 +93,8 @@ Module {
             if (xcodeDeveloperPath && useXcodeBuildSpecs) {
                 specsPaths = Bundle.macOSSpecsPaths(xcodeVersion, xcodeDeveloperPath);
                 specsSeparator = " ";
+                if (Utilities.versionCompare(xcodeVersion, "26.0") >= 0)
+                    specsSeparator = "";
             }
 
             var reader = new Bundle.XcodeBuildSpecsReader(specsPaths,
diff --git a/share/qbs/modules/xcode/xcode.js b/share/qbs/modules/xcode/xcode.js
index 726974579039fe6bd746b1eee7c49c112086e4bc..4706272851b13f8b9eb79ee503828286981296fd 100644
--- a/share/qbs/modules/xcode/xcode.js
+++ b/share/qbs/modules/xcode/xcode.js
@@ -202,6 +202,32 @@ function boolFromSdkOrPlatform(varName, sdkProps, platformProps, defaultValue) {
     return defaultValue;
 }
 
+function specsBaseName(version, targetOS) {
+    const targetPlatform = targetOS[0];
+    const oldSpecNames = {
+        "macos": "MacOSX Architectures",
+        "ios": "iOS Device",
+        "ios-simulator": "iOS Simulator",
+        "tvos": "tvOS Device",
+        "tvos-simulator": "tvOS Simulator",
+        "watchos": "watchOS Device",
+        "watchos-simulator": "watchOS Simulator"
+    };
+    const newSpecNames = {
+        "macos": "macOSArchitectures",
+        "ios": "iOSDevice",
+        "ios-simulator": "iOSSimulator",
+        "tvos": "tvOSDevice",
+        "tvos-simulator": "tvOSSimulator",
+        "watchos": "watchOSDevice",
+        "watchos-simulator": "watchOSSimulator"
+    };
+    if (Utilities.versionCompare(version, "26") < 0) {
+        return oldSpecNames[targetPlatform];
+    }
+    return newSpecNames[targetPlatform];
+}
+
 function archsSpecsPath(version, targetOS, platformType, platformPath, devicePlatformPath,
                         developerPath) {
     if (Utilities.versionCompare(version, "13.3") >= 0) {
@@ -218,13 +244,7 @@ function archsSpecsPath(version, targetOS, platformType, platformPath, devicePla
         var baseDir = FileInfo.joinPaths(pluginsDir,
                                          "XCBSpecifications.ideplugin", "Contents", "Resources");
 
-        var baseName = targetOS.includes("macos") ? "MacOSX Architectures"
-                : targetOS.includes("ios-simulator") ? "iOS Simulator"
-                : targetOS.includes("ios") ? "iOS Device"
-                : targetOS.includes("tvos-simulator") ? "tvOS Simulator"
-                : targetOS.includes("tvos") ? "tvOS Device"
-                : targetOS.includes("watchos-simulator") ? "watchOS Simulator" : "watchOS Device";
-        return FileInfo.joinPaths(baseDir, baseName + ".xcspec");
+        return FileInfo.joinPaths(baseDir, specsBaseName(version, targetOS) + ".xcspec");
     }
     var _specsPluginBaseName;
     if (Utilities.versionCompare(version, "12") >= 0) {
