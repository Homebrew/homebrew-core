class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.02/nsis-3.02-src.tar.bz2"
  sha256 "c44ad18462c56ada4b4303513997076b960f7a991993c5c43ae0edb4936dd83d"

  bottle do
    cellar :any_skip_relocation
    sha256 "8206444a401eff06bc19c3ecdc1b274b98ca41d016dc6c711043253d695e0e6b" => :sierra
    sha256 "6ec50d87ec160773bc73f161243dba8c1a9f2811b41e95ea55fe9da389aa4444" => :el_capitan
    sha256 "5c116395f0a53447856051885ef9c606e60ab8925cb9ec97a21cf72c2c90097d" => :yosemite
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.02/nsis-3.02.zip"
    sha256 "b63bf7cb1e2522754ccb5628e54277f553bc6810d6229d0fe7eb1d78b3457206"
  end

  # v1.2.8 is outdated, but the last version available as compiled DLL
  resource "zlib-win32" do
    url "https://downloads.sourceforge.net/project/libpng/zlib/1.2.8/zlib128-dll.zip"
    sha256 "a03fd15af45e91964fb980a30422073bc3f3f58683e9fdafadad3f7db10762b1"
  end

  # scons appears to have no builtin way to override the compiler selection,
  # and the only options supported on macOS are 'gcc' and 'g++'.
  # Use the right compiler by forcibly altering the scons config to set these
  patch :DATA

  def install
    # makensis fails to build under libc++; since it's just a binary with
    # no Homebrew dependencies, we can just use libstdc++
    # https://sourceforge.net/p/nsis/bugs/1085/
    ENV.libstdcxx if ENV.compiler == :clang

    # requires zlib (win32) to build utils
    resource("zlib-win32").stage do
      @zlib_path = Dir.pwd
    end

    # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
    scons "STRIP=0", "ZLIB_W32=#{@zlib_path}", "SKIPUTILS=NSIS Menu", "makensis"
    bin.install "build/urelease/makensis/makensis"
    (share/"nsis").install resource("nsis")
  end

  test do
    system "#{bin}/makensis", "-VERSION"
  end
end

__END__
diff --git a/SCons/config.py b/SCons/config.py
index a344456..37c575b 100755
--- a/SCons/config.py
+++ b/SCons/config.py
@@ -1,3 +1,5 @@
+import os
+
 Import('defenv')
 
 ### Configuration options
@@ -440,6 +442,9 @@ Help(cfg.GenerateHelpText(defenv))
 env = Environment()
 cfg.Update(env)
 
+defenv['CC'] = os.environ['CC']
+defenv['CXX'] = os.environ['CXX']
+
 def AddValuedDefine(define):
   defenv.Append(NSIS_CPPDEFINES = [(define, env[define])])
