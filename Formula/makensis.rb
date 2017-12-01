class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.02.1/nsis-3.02.1-src.tar.bz2"
  sha256 "5f6d135362c70f6305317b3af6d8398184ac1a22d3f23b9c4164543c13fb8d60"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "cc8686bdbe846eb671e675d3ae8ed9509302c7b07383e2cb8115918f5a1703f7" => :high_sierra
    sha256 "d3e70c2d9bb6a83fe459e74617dcda2e6f3623ac79075271f652a12f7f18a3be" => :sierra
    sha256 "23016ec85306c8b7694cdfad5e3a87c6ae22ad8f4b6b66995bc325181a593454" => :el_capitan
  end

  # From https://nsis.sourceforge.io/Special_Builds#Advanced_logging
  option "with-advanced-logging", "Enable advanced logging of all installer actions"

  # Build makensis so installers can handle strings > 1024 characters
  # From https://nsis.sourceforge.io/Special_Builds#Large_strings
  # Upstream RFE to make this default the default behavior is
  # https://sourceforge.net/p/nsis/feature-requests/542/
  option "with-large-strings", "Enable strings up to 8192 characters instead of default 1024"

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
    args = ["STRIP=0", "ZLIB_W32=#{@zlib_path}", "SKIPUTILS=NSIS Menu",
            "PREFIX_DOC=#{share}/nsis/Docs", "VERSION=#{version}"]
    args << "NSIS_CONFIG_LOG=yes" if build.with? "advanced-logging"
    args << "NSIS_MAX_STRLEN=8192" if build.with? "large-strings"
    scons "makensis", *args
    bin.install "build/urelease/makensis/makensis"
    (share/"nsis").install resource("nsis")
  end

  test do
    system "#{bin}/makensis", "-VERSION"
    (testpath/"test.nsi").write <<~EOS
      # name the installer
      OutFile "test.exe"
      # default section start; every NSIS script has at least one section.
      Section
      # default section end
      SectionEnd
    EOS
    system "#{bin}/makensis", "#{testpath}/test.nsi"
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
