class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound.git",
      tag:      "7.0.0",
      revision: "c58f4de6b8056b9356f31615b395b3bfd9bd0775"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 1
  head "https://github.com/csound/csound.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_golden_gate: "7709c6410f805f7f2e5d6beb8d1cb375faefd1e73c083d5fb791dcc8e683d155"
    sha256 arm64_tahoe:       "85145fdf22bcc9615baceea4717b8ed96fc01d38d8c84778d7e2dbb72189d3fa"
    sha256 arm64_sequoia:     "7868cf70cee80c7209c9bc5e76b3801c978e78b147b96c72fa9cac914fe35c57"
    sha256 arm64_linux:       "12d5059cc8ad64c50aaacc20037f9f122caa5627e8b0a7dcc55d3926fa9f604f"
    sha256 x86_64_linux:      "6be0996a84845a6e6bfa0d09d0765c441fd902e94a18309ba14df3105fc374d5"
  end

  depends_on "asio" => :build
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "jack"
  depends_on "lame"
  depends_on "liblo"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "python@3.15"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "pipewire"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "libextractor", because: "both install `extract` binaries"

  # Honour `CS_OPCODE_DIR` on Linux like on macOS: https://github.com/csound/csound/pull/3610
  # Don't write to the compiled-in plugin search path when it has several directories:
  # https://github.com/csound/csound/pull/3555
  patch :DATA

  def install
    rpaths = [rpath]
    rpaths << rpath(target: frameworks) if OS.mac?

    api_version = version.major_minor
    plugin_dirs = if OS.mac?
      [frameworks/"CsoundLib64.framework/Versions/#{api_version}/Resources/Opcodes64"]
    else
      [lib/"csound/plugins64-#{api_version}"]
    end
    # Also search the `csound-plugins` formula, which is silently skipped when not installed
    plugin_dirs << (formula_opt_lib("csound-plugins")/"csound/plugins64-#{api_version}")

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DBISON_EXECUTABLE=#{formula_opt_bin("bison")}/bison
      -DBUILD_TESTS=OFF
      -DCS_FRAMEWORK_DEST=#{frameworks}
      -DCS_OPCODE_DIR=#{plugin_dirs.join(":")}
      -DINSTALL_PYTHON_INTERFACE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      include.install_symlink frameworks/"CsoundLib64.framework/Headers" => "csound"
    else
      # On Linux, csound depends on binutils, but both formulae install `srconv` binaries
      (bin/"srconv").unlink
    end
  end

  def caveats
    on_linux do
      <<~EOS
        srconv is not installed because it conflicts with binutils. To run srconv:
          csound --utility=srconv
      EOS
    end
  end

  test do
    (testpath/"test.orc").write <<~ORC
      0dbfs = 1
      instr 1
          out oscils(0.5 * 0dbfs, 440, 0)
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

    system bin/"csound", "test.orc", "test.sco"

    assert_path_exists testpath/"test.#{OS.mac? ? "aif" : "wav"}"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -744,8 +744,10 @@ else()
 endif()
 
 if(LINUX)
-    set(DEFAULT_OPCODEDIR "${PLUGIN_INSTALL_DIR}")
-    add_definitions("-DCS_DEFAULT_PLUGINDIR=\"${DEFAULT_OPCODEDIR}\"")
+    if(CS_OPCODE_DIR STREQUAL "")
+        set(DEFAULT_OPCODEDIR "${PLUGIN_INSTALL_DIR}")
+        add_definitions("-DCS_DEFAULT_PLUGINDIR=\"${DEFAULT_OPCODEDIR}\"")
+    endif()
     # dir relative to $HOME
     if(USE_DOUBLE)
         set(DEFAULT_USER_PLUGINDIR ".local/lib/csound/${APIVERSION}/plugins64")
diff --git a/Top/csmodule.c b/Top/csmodule.c
--- a/Top/csmodule.c
+++ b/Top/csmodule.c
@@ -674,11 +674,11 @@ int32_t csoundLoadModules(CSOUND *csound)
 #if (defined(HAVE_DIRENT_H) && (TARGET_OS_IPHONE == 0))
   DIR *dir;
   struct dirent *f;
-  const char *dname, *fname;
+  const char *dname, *fname, *end;
   enum { searchpath_buflen = 2048, buflen = 1024 };
   char buf[buflen];
   int32_t i, n, len, err = CSOUND_SUCCESS;
-  char *dname1, *end;
+  char *dname1;
   int32_t read_directory = 1;
   int32_t warn_bad_directory = 0;
   const char *userplugindir_start = NULL;
@@ -768,11 +768,11 @@ int32_t csoundLoadModules(CSOUND *csound)
   while(read_directory) {
     /* find separator */
     if((end = strchr(dname, sep)) != NULL) {
-      *end = '\0';
-      /* copy directory name */
-      dname1 = csoundStrdup(csound, (char *) dname);
-
-      *end = sep;  /* restore for re-execution */
+      /* Copy the directory without changing the source search path. */
+      size_t dirlen = (size_t) (end - dname);
+      dname1 = csound->Malloc(csound, dirlen + 1);
+      memcpy(dname1, dname, dirlen);
+      dname1[dirlen] = '\0';
       /* move to next directory name */
       dname = end + 1;
       if (dname == userplugindir_start)
@@ -780,7 +780,7 @@ int32_t csoundLoadModules(CSOUND *csound)
 
     } else {
       /* copy last directory name) */
-      dname1 = csoundStrdup(csound, (char *) dname);
+      dname1 = csoundStrdup(csound, dname);
       read_directory = 0;
     }
 
@@ -1059,10 +1059,10 @@ int32_t csoundLoadAndInitModules(CSOUND *csound, const char *opdir){
 #if (defined(HAVE_DIRENT_H) && (TARGET_OS_IPHONE == 0))
   DIR             *dir;
   struct dirent   *f;
-  const char      *dname, *fname;
+  const char      *dname, *fname, *end;
   char            buf[1024];
   int32_t         i, n, len, err = CSOUND_SUCCESS;
-  char            *dname1, *end;
+  char            *dname1;
   int32_t         read_directory = 1;
   char sep =
 #ifdef WIN32
@@ -1108,15 +1108,16 @@ int32_t csoundLoadAndInitModules(CSOUND *csound, const char *opdir){
   while(read_directory) {
     /* find separator */
     if((end = strchr(dname, sep)) != NULL) {
-      *end = '\0';
-      /* copy directory name */
-      dname1 = csoundStrdup(csound, (char *) dname);
-      *end = sep;  /* restore for re-execution */
+      /* Copy the directory without changing the source search path. */
+      size_t dirlen = (size_t) (end - dname);
+      dname1 = csound->Malloc(csound, dirlen + 1);
+      memcpy(dname1, dname, dirlen);
+      dname1[dirlen] = '\0';
       /* move to next directory name */
       dname = end + 1;
     } else {
       /* copy last directory name) */
-      dname1 = csoundStrdup(csound, (char *) dname);
+      dname1 = csoundStrdup(csound, dname);
       read_directory = 0;
     }
 
