class CodaCli < Formula
  include Language::Python::Shebang

  desc "Shell integration for Panic's Coda"
  homepage "http://justinhileman.info/coda-cli/"
  url "https://github.com/bobthecow/coda-cli/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "5ed407313a8d1fc6cc4d5b1acc14a80f7e6fad6146f2334de510e475955008b9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "483e4c98217844164a568e721fa48ab165e16c6649b3320c2f7811850c1504cb"
  end

  # originally written in py2, and has not been updated since 2012-05-30
  deprecate! date: "2024-08-03", because: :unmaintained
  disable! date: "2025-08-03", because: :unmaintained

  uses_from_macos "python"

  # update to use python3
  patch :DATA

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "coda"
    bin.install "coda"
  end

  test do
    system bin/"coda", "-h"
  end
end

__END__
diff --git a/coda b/coda
index 2f36414..704adae 100755
--- a/coda
+++ b/coda
@@ -49,13 +49,13 @@ License:
     Distributed under the MIT License - http://creativecommons.org/licenses/MIT/

 """
-import sys, os, time, commands, optparse, signal
+import sys, os, time, subprocess, optparse, signal
 from tempfile import mkstemp
 from pipes import quote

 version = '1.0.5'

-if commands.getoutput("mdfind \"kMDItemCFBundleIdentifier == 'com.panic.Coda2'\"") != "":
+if subprocess.getoutput("mdfind \"kMDItemCFBundleIdentifier == 'com.panic.Coda2'\"") != "":
     bundle_id = 'com.panic.Coda2'
 else:
     bundle_id = 'com.panic.Coda'
@@ -81,7 +81,7 @@ parser.version = "%%prog: %s" % version
 signal.signal(signal.SIGINT, lambda *x: sys.exit(1))

 def osascript(scpt):
-    return commands.getoutput("osascript 2>/dev/null <<ENDSCRIPT\n%s\nENDSCRIPT\n:" % scpt)
+    return subprocess.getoutput("osascript 2>/dev/null <<ENDSCRIPT\n%s\nENDSCRIPT\n:" % scpt)

 def coda_is_running():
     return osascript("tell application \"System Events\" to (count (every process whose creator type is \"TStu\")) as boolean") == "true"
@@ -107,7 +107,7 @@ def open_tabs():
             """ % (bundle_id, guts)

     if coda_is_running():
-        return [os.path.realpath(tab) for tab in filter(lambda a: a != "missing value" and a != "", osascript(scpt).rstrip("\n").split("\n"))]
+        return [os.path.realpath(tab) for tab in [a for a in osascript(scpt).rstrip("\n").split("\n") if a != "missing value" and a != ""]]
     else:
         return []

@@ -135,7 +135,7 @@ if options.version:
 if options.lstabs:
     tabs = open_tabs()
     if tabs:
-        print "\n".join(tabs)
+        print("\n".join(tabs))
     exit()

 if options.new_window and coda_is_running():
