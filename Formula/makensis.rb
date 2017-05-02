class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.io/"

  stable do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.01/nsis-3.01-src.tar.bz2"
    sha256 "604c011593be484e65b2141c50a018f1b28ab28c994268e4ecd377773f3ffba1"

    resource "nsis" do
      url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.01/nsis-3.01.zip"
      sha256 "daa17556c8690a34fb13af25c87ced89c79a36a935bf6126253a9d9a5226367c"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e18b6829e0db4cf473b1869cff4a21d3a3a1bd9a82bf267ec9a04b24b60dfbd6" => :sierra
    sha256 "b9facea6fcb40112469e564a42b68a3e93f9b53ad1671c50d62ce7e7832546ef" => :el_capitan
    sha256 "867cf5c8c0699cc8d3ce570571ef883cd6a2ebf0ac657e5091ed60b4b03ff88b" => :yosemite
  end

  depends_on "cppunit" => :build
  depends_on "mingw-w64" => :build
  depends_on "scons" => :build
  depends_on "zlib" => :build

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
