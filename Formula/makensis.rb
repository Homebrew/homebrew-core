class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.02.1/nsis-3.02.1-src.tar.bz2"
  sha256 "5f6d135362c70f6305317b3af6d8398184ac1a22d3f23b9c4164543c13fb8d60"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad705d703ce08086971ea662c0aaf9fd794c0f141e415680222e0cc20e5e4929" => :sierra
    sha256 "7e40085a63e244754a62213d00084fce86ff2d77d0ad2c29427fca244087bcc3" => :el_capitan
    sha256 "91f586655bf0ce929e42a5f5868b2c4f15d6608a964a5430fedf78e1ebebf3e3" => :yosemite
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.02.1/nsis-3.02.1.zip"
    sha256 "deef3e3d90ab1a9e0ef294fff85eead25edbcb429344ad42fc9bc42b5c3b1fb5"
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
