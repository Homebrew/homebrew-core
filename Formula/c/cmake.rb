class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.1/cmake-3.31.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.31.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.31.1.tar.gz"
  sha256 "c4fc2a9bd0cd5f899ccb2fb81ec422e175090bc0de5d90e906dd453b53065719"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c50ea55135f1fd6c58900cab723418aef1dfcca2e8307b459978ba437c1256a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1e5d394cfe35d716d36f51b50bed3a0320fbf97a206dafeda92af09a65beac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "388811eceeb7e9ed4c5c1c343af5e471ff5904a5082048f9c28d0744bec61543"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3f0f2104d0271e6d7d10a816746c5eddd6df5408f5b33f9e8cc7a7cd070cd60"
    sha256 cellar: :any_skip_relocation, ventura:       "ecb13b012cb924d5f7dfcf5f223d014db323642e4fec2ec9967c066824ca9306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9120cf711be3a8e03ef011a0eae29c5e3150c27dbad1cd5ea53590405738fe1b"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  # Prevent the formula from breaking on version/revision bumps.
  # Check if possible to remove in 3.32.0
  # https://gitlab.kitware.com/cmake/cmake/-/merge_requests/9987
  patch :DATA

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end

__END__
diff --git a/Source/cmSystemTools.cxx b/Source/cmSystemTools.cxx
index 5ad0439c9ee..f03f8bd3cd0 100644
--- a/Source/cmSystemTools.cxx
+++ b/Source/cmSystemTools.cxx
@@ -1628,6 +1628,13 @@ std::vector<std::string> cmSystemTools::SplitEnvPath(std::string const& value)
   return paths;
 }
 
+std::string cmSystemTools::ToNormalizedPathOnDisk(std::string p)
+{
+  p = cmSystemTools::CollapseFullPath(p);
+  cmSystemTools::ConvertToUnixSlashes(p);
+  return p;
+}
+
 #ifndef CMAKE_BOOTSTRAP
 bool cmSystemTools::UnsetEnv(const char* value)
 {
@@ -2513,30 +2520,48 @@ unsigned int cmSystemTools::RandomSeed()
 #endif
 }
 
-static std::string cmSystemToolsCMakeCommand;
-static std::string cmSystemToolsCTestCommand;
-static std::string cmSystemToolsCPackCommand;
-static std::string cmSystemToolsCMakeCursesCommand;
-static std::string cmSystemToolsCMakeGUICommand;
-static std::string cmSystemToolsCMClDepsCommand;
-static std::string cmSystemToolsCMakeRoot;
-static std::string cmSystemToolsHTMLDoc;
-void cmSystemTools::FindCMakeResources(const char* argv0)
+namespace {
+std::string InitLogicalWorkingDirectory()
+{
+  std::string cwd = cmsys::SystemTools::GetCurrentWorkingDirectory();
+  std::string pwd;
+  if (cmSystemTools::GetEnv("PWD", pwd)) {
+    std::string const pwd_real = cmSystemTools::GetRealPath(pwd);
+    if (pwd_real == cwd) {
+      cwd = std::move(pwd);
+    }
+  }
+  return cwd;
+}
+
+std::string cmSystemToolsLogicalWorkingDirectory =
+  InitLogicalWorkingDirectory();
+
+std::string cmSystemToolsCMakeCommand;
+std::string cmSystemToolsCTestCommand;
+std::string cmSystemToolsCPackCommand;
+std::string cmSystemToolsCMakeCursesCommand;
+std::string cmSystemToolsCMakeGUICommand;
+std::string cmSystemToolsCMClDepsCommand;
+std::string cmSystemToolsCMakeRoot;
+std::string cmSystemToolsHTMLDoc;
+
+#if defined(__APPLE__)
+bool IsCMakeAppBundleExe(std::string const& exe)
+{
+  return cmHasLiteralSuffix(cmSystemTools::LowerCase(exe), "/macos/cmake");
+}
+#endif
+
+std::string FindOwnExecutable(const char* argv0)
 {
-  std::string exe_dir;
 #if defined(_WIN32) && !defined(__CYGWIN__)
-  (void)argv0; // ignore this on windows
+  static_cast<void>(argv0);
   wchar_t modulepath[_MAX_PATH];
   ::GetModuleFileNameW(nullptr, modulepath, sizeof(modulepath));
-  std::string path = cmsys::Encoding::ToNarrow(modulepath);
-  std::string realPath =
-    cmSystemTools::GetRealPathResolvingWindowsSubst(path, nullptr);
-  if (realPath.empty()) {
-    realPath = path;
-  }
-  exe_dir = cmSystemTools::GetFilenamePath(realPath);
+  std::string exe = cmsys::Encoding::ToNarrow(modulepath);
 #elif defined(__APPLE__)
-  (void)argv0; // ignore this on OS X
+  static_cast<void>(argv0);
 #  define CM_EXE_PATH_LOCAL_SIZE 16384
   char exe_path_local[CM_EXE_PATH_LOCAL_SIZE];
 #  if defined(MAC_OS_X_VERSION_10_3) && !defined(MAC_OS_X_VERSION_10_4)
@@ -2550,41 +2575,133 @@ void cmSystemTools::FindCMakeResources(const char* argv0)
     exe_path = static_cast<char*>(malloc(exe_path_size));
     _NSGetExecutablePath(exe_path, &exe_path_size);
   }
-  exe_dir =
-    cmSystemTools::GetFilenamePath(cmSystemTools::GetRealPath(exe_path));
+  std::string exe = exe_path;
   if (exe_path != exe_path_local) {
     free(exe_path);
   }
-  if (cmSystemTools::GetFilenameName(exe_dir) == "MacOS") {
+  if (IsCMakeAppBundleExe(exe)) {
     // The executable is inside an application bundle.
-    // Look for ..<CMAKE_BIN_DIR> (install tree) and then fall back to
-    // ../../../bin (build tree).
-    exe_dir = cmSystemTools::GetFilenamePath(exe_dir);
-    if (cmSystemTools::FileExists(exe_dir + CMAKE_BIN_DIR "/cmake")) {
-      exe_dir += CMAKE_BIN_DIR;
-    } else {
-      exe_dir = cmSystemTools::GetFilenamePath(exe_dir);
-      exe_dir = cmSystemTools::GetFilenamePath(exe_dir);
+    // The install tree has "..<CMAKE_BIN_DIR>/cmake-gui".
+    // The build tree has '../../../cmake-gui".
+    std::string dir = cmSystemTools::GetFilenamePath(exe);
+    dir = cmSystemTools::GetFilenamePath(dir);
+    exe = cmStrCat(dir, CMAKE_BIN_DIR "/cmake-gui");
+    if (!cmSystemTools::PathExists(exe)) {
+      dir = cmSystemTools::GetFilenamePath(dir);
+      dir = cmSystemTools::GetFilenamePath(dir);
+      exe = cmStrCat(dir, "/cmake-gui");
     }
   }
 #else
   std::string errorMsg;
   std::string exe;
-  if (cmSystemTools::FindProgramPath(argv0, exe, errorMsg)) {
-    // remove symlinks
-    exe = cmSystemTools::GetRealPath(exe);
-    exe_dir = cmSystemTools::GetFilenamePath(exe);
-  } else {
+  if (!cmSystemTools::FindProgramPath(argv0, exe, errorMsg)) {
     // ???
   }
 #endif
-  exe_dir = cmSystemTools::GetActualCaseForPath(exe_dir);
-  cmSystemToolsCMakeCommand =
-    cmStrCat(exe_dir, "/cmake", cmSystemTools::GetExecutableExtension());
+  exe = cmSystemTools::ToNormalizedPathOnDisk(std::move(exe));
+  return exe;
+}
+
+#ifndef CMAKE_BOOTSTRAP
+bool ResolveSymlinkToOwnExecutable(std::string& exe, std::string& exe_dir)
+{
+  std::string linked_exe;
+  if (!cmSystemTools::ReadSymlink(exe, linked_exe)) {
+    return false;
+  }
+#  if defined(__APPLE__)
+  // Ignore "cmake-gui -> ../MacOS/CMake".
+  if (IsCMakeAppBundleExe(linked_exe)) {
+    return false;
+  }
+#  endif
+  if (cmSystemTools::FileIsFullPath(linked_exe)) {
+    exe = std::move(linked_exe);
+  } else {
+    exe = cmStrCat(exe_dir, '/', std::move(linked_exe));
+  }
+  exe = cmSystemTools::ToNormalizedPathOnDisk(std::move(exe));
+  exe_dir = cmSystemTools::GetFilenamePath(exe);
+  return true;
+}
+
+bool FindCMakeResourcesInInstallTree(std::string const& exe_dir)
+{
+  // Install tree has
+  // - "<prefix><CMAKE_BIN_DIR>/cmake"
+  // - "<prefix><CMAKE_DATA_DIR>"
+  // - "<prefix><CMAKE_DOC_DIR>"
+  if (cmHasLiteralSuffix(exe_dir, CMAKE_BIN_DIR)) {
+    std::string const prefix =
+      exe_dir.substr(0, exe_dir.size() - cmStrLen(CMAKE_BIN_DIR));
+    // Set cmSystemToolsCMakeRoot set to the location expected in an
+    // install tree, even if it does not exist, so that
+    // cmake::AddCMakePaths can print the location in its error message.
+    cmSystemToolsCMakeRoot = cmStrCat(prefix, CMAKE_DATA_DIR);
+    if (cmSystemTools::FileExists(
+          cmStrCat(cmSystemToolsCMakeRoot, "/Modules/CMake.cmake"))) {
+      if (cmSystemTools::FileExists(
+            cmStrCat(prefix, CMAKE_DOC_DIR "/html/index.html"))) {
+        cmSystemToolsHTMLDoc = cmStrCat(prefix, CMAKE_DOC_DIR "/html");
+      }
+      return true;
+    }
+  }
+  return false;
+}
+
+void FindCMakeResourcesInBuildTree(std::string const& exe_dir)
+{
+  // Build tree has "<build>/bin[/<config>]/cmake" and
+  // "<build>/CMakeFiles/CMakeSourceDir.txt".
+  std::string dir = cmSystemTools::GetFilenamePath(exe_dir);
+  std::string src_dir_txt = cmStrCat(dir, "/CMakeFiles/CMakeSourceDir.txt");
+  cmsys::ifstream fin(src_dir_txt.c_str());
+  std::string src_dir;
+  if (fin && cmSystemTools::GetLineFromStream(fin, src_dir) &&
+      cmSystemTools::FileIsDirectory(src_dir)) {
+    cmSystemToolsCMakeRoot = src_dir;
+  } else {
+    dir = cmSystemTools::GetFilenamePath(dir);
+    src_dir_txt = cmStrCat(dir, "/CMakeFiles/CMakeSourceDir.txt");
+    cmsys::ifstream fin2(src_dir_txt.c_str());
+    if (fin2 && cmSystemTools::GetLineFromStream(fin2, src_dir) &&
+        cmSystemTools::FileIsDirectory(src_dir)) {
+      cmSystemToolsCMakeRoot = src_dir;
+    }
+  }
+  if (!cmSystemToolsCMakeRoot.empty() && cmSystemToolsHTMLDoc.empty() &&
+      cmSystemTools::FileExists(
+        cmStrCat(dir, "/Utilities/Sphinx/html/index.html"))) {
+    cmSystemToolsHTMLDoc = cmStrCat(dir, "/Utilities/Sphinx/html");
+  }
+}
+#endif
+}
+
+void cmSystemTools::FindCMakeResources(const char* argv0)
+{
+  std::string exe = FindOwnExecutable(argv0);
 #ifdef CMAKE_BOOTSTRAP
+  // The bootstrap cmake knows its resource locations.
+  cmSystemToolsCMakeRoot = CMAKE_BOOTSTRAP_SOURCE_DIR;
+  cmSystemToolsCMakeCommand = exe;
   // The bootstrap cmake does not provide the other tools,
   // so use the directory where they are about to be built.
-  exe_dir = CMAKE_BOOTSTRAP_BINARY_DIR "/bin";
+  std::string exe_dir = CMAKE_BOOTSTRAP_BINARY_DIR "/bin";
+#else
+  // Find resources relative to our own executable.
+  std::string exe_dir = cmSystemTools::GetFilenamePath(exe);
+  bool found = false;
+  do {
+    found = FindCMakeResourcesInInstallTree(exe_dir);
+  } while (!found && ResolveSymlinkToOwnExecutable(exe, exe_dir));
+  if (!found) {
+    FindCMakeResourcesInBuildTree(exe_dir);
+  }
+  cmSystemToolsCMakeCommand =
+    cmStrCat(exe_dir, "/cmake", cmSystemTools::GetExecutableExtension());
 #endif
   cmSystemToolsCTestCommand =
     cmStrCat(exe_dir, "/ctest", cmSystemTools::GetExecutableExtension());
@@ -2605,52 +2722,6 @@ void cmSystemTools::FindCMakeResources(const char* argv0)
   if (!cmSystemTools::FileExists(cmSystemToolsCMClDepsCommand)) {
     cmSystemToolsCMClDepsCommand.clear();
   }
-
-#ifndef CMAKE_BOOTSTRAP
-  // Install tree has
-  // - "<prefix><CMAKE_BIN_DIR>/cmake"
-  // - "<prefix><CMAKE_DATA_DIR>"
-  // - "<prefix><CMAKE_DOC_DIR>"
-  if (cmHasLiteralSuffix(exe_dir, CMAKE_BIN_DIR)) {
-    std::string const prefix =
-      exe_dir.substr(0, exe_dir.size() - cmStrLen(CMAKE_BIN_DIR));
-    cmSystemToolsCMakeRoot = cmStrCat(prefix, CMAKE_DATA_DIR);
-    if (cmSystemTools::FileExists(
-          cmStrCat(prefix, CMAKE_DOC_DIR "/html/index.html"))) {
-      cmSystemToolsHTMLDoc = cmStrCat(prefix, CMAKE_DOC_DIR "/html");
-    }
-  }
-  if (cmSystemToolsCMakeRoot.empty() ||
-      !cmSystemTools::FileExists(
-        cmStrCat(cmSystemToolsCMakeRoot, "/Modules/CMake.cmake"))) {
-    // Build tree has "<build>/bin[/<config>]/cmake" and
-    // "<build>/CMakeFiles/CMakeSourceDir.txt".
-    std::string dir = cmSystemTools::GetFilenamePath(exe_dir);
-    std::string src_dir_txt = cmStrCat(dir, "/CMakeFiles/CMakeSourceDir.txt");
-    cmsys::ifstream fin(src_dir_txt.c_str());
-    std::string src_dir;
-    if (fin && cmSystemTools::GetLineFromStream(fin, src_dir) &&
-        cmSystemTools::FileIsDirectory(src_dir)) {
-      cmSystemToolsCMakeRoot = src_dir;
-    } else {
-      dir = cmSystemTools::GetFilenamePath(dir);
-      src_dir_txt = cmStrCat(dir, "/CMakeFiles/CMakeSourceDir.txt");
-      cmsys::ifstream fin2(src_dir_txt.c_str());
-      if (fin2 && cmSystemTools::GetLineFromStream(fin2, src_dir) &&
-          cmSystemTools::FileIsDirectory(src_dir)) {
-        cmSystemToolsCMakeRoot = src_dir;
-      }
-    }
-    if (!cmSystemToolsCMakeRoot.empty() && cmSystemToolsHTMLDoc.empty() &&
-        cmSystemTools::FileExists(
-          cmStrCat(dir, "/Utilities/Sphinx/html/index.html"))) {
-      cmSystemToolsHTMLDoc = cmStrCat(dir, "/Utilities/Sphinx/html");
-    }
-  }
-#else
-  // Bootstrap build knows its source.
-  cmSystemToolsCMakeRoot = CMAKE_BOOTSTRAP_SOURCE_DIR;
-#endif
 }
 
 std::string const& cmSystemTools::GetCMakeCommand()
diff --git a/Source/cmSystemTools.h b/Source/cmSystemTools.h
index 0531f63b84a..d74a6e1c16e 100644
--- a/Source/cmSystemTools.h
+++ b/Source/cmSystemTools.h
@@ -401,6 +401,8 @@ class cmSystemTools : public cmsys::SystemTools
   static cm::optional<std::string> GetEnvVar(std::string const& var);
   static std::vector<std::string> SplitEnvPath(std::string const& value);
 
+  static std::string ToNormalizedPathOnDisk(std::string p);
+
 #ifndef CMAKE_BOOTSTRAP
   /** Remove an environment variable */
   static bool UnsetEnv(const char* value);
