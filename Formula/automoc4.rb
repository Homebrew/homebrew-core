class Automoc4 < Formula
  desc "Tool to add rules for generating Qt moc files"
  homepage "https://techbase.kde.org/Development/Tools/Automoc4"
  url "http://download.kde.org/stable/automoc4/0.9.88/automoc4-0.9.88.tar.bz2"
  sha256 "234116f4c05ae21d828594d652b4c4a052ef75727e2d8a4f3a4fb605de9e4c49"

  bottle do
    sha256 "3f9efbccd2e54425aefa23beb359a84790a702fbc83e7950a709b3a56c818898" => :el_capitan
    sha256 "db251dc1e60d49c6ba011c28cf4d08f82468af379195c66fc5e7777b6e9fc4fd" => :yosemite
    sha256 "86fc5bddf7faf6f2897fc626903f0d927c8c9094e41c3d238c4b3e718acf4f47" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "qt"

  # Patch needed to find Qt in Homebrew upstreamed but upstream version
  # does not apply. Won't be needed for next version.
  # https://projects.kde.org/projects/kdesupport/automoc/repository/revisions/6b9597ff
  patch :p0, :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

__END__
--- kde4automoc.cpp.old	2009-01-22 18:50:09.000000000 +0000
+++ kde4automoc.cpp	2010-03-15 22:26:03.000000000 +0000
@@ -175,16 +175,22 @@
     dotFilesCheck(line == "MOC_INCLUDES:\n");
     line = dotFiles.readLine().trimmed();
     const QStringList &incPaths = QString::fromUtf8(line).split(';', QString::SkipEmptyParts);
+    QSet<QString> frameworkPaths;
     foreach (const QString &path, incPaths) {
         Q_ASSERT(!path.isEmpty());
         mocIncludes << "-I" + path;
+        if (path.endsWith(".framework/Headers")) {
+            QDir framework(path);
+            // Go up twice to get to the framework root
+            framework.cdUp();
+            framework.cdUp();
+            frameworkPaths << framework.path();
+        }
     }
 
-    // on the Mac, add -F always, otherwise headers in the frameworks won't be found
-    // is it necessary to do this only optionally ? Alex
-#ifdef Q_OS_MAC
-    mocIncludes << "-F/Library/Frameworks";
-#endif
+    foreach (const QString &path, frameworkPaths) {
+        mocIncludes << "-F" << path;
+    }
 
     line = dotFiles.readLine();
     dotFilesCheck(line == "CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE:\n");
