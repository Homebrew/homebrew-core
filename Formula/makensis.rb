class Makensis < Formula
  desc "System to create Windows installers"
  homepage "http://nsis.sourceforge.net/"

  stable do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%202/2.51/nsis-2.51-src.tar.bz2"
    sha256 "43d4c9209847e35eb6e2c7cd5a7586e1445374c056c2c7899e40a080e17a1be7"

    resource "nsis" do
      url "https://downloads.sourceforge.net/project/nsis/NSIS%202/2.51/nsis-2.51.zip"
      sha256 "43065a52a586166174c87294ae322baef898af8b782019e8a7ffd625f64f8e35"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3fe7c4c515178d9f03d41c1cdae529b757a4dc0677590878af36c5ad18139da2" => :el_capitan
    sha256 "dfb81426bb147fe471cb314647c91862e45f27a7a72773685e20421d504ac6c4" => :yosemite
    sha256 "df608eed02642d4f9dfbc230e175e460e9769d351acbd9411455ad4333cf1282" => :mavericks
  end

  devel do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203%20Pre-release/3.0b3/nsis-3.0b3-src.tar.bz2"
    sha256 "faf22d6cd4bd46780afcf22524a1de39bcc38c85773719ec7a1ecf002e308d3a"

    resource "nsis" do
      url "https://downloads.sourceforge.net/project/nsis/NSIS%203%20Pre-release/3.0b3/nsis-3.0b3.zip"
      sha256 "8eee1f0f31c5f776cb2aa34197f906220c9ed43918424eb5bced3ca773e58b10"
    end
  end

  depends_on "scons" => :build

  # scons appears to have no builtin way to override the compiler selection,
  # and the only options supported on OS X are 'gcc' and 'g++'.
  # Use the right compiler by forcibly altering the scons config to set these
  patch :DATA

  def install
    # makensis fails to build under libc++; since it's just a binary with
    # no Homebrew dependencies, we can just use libstdc++
    # https://sourceforge.net/p/nsis/bugs/1085/
    ENV.libstdcxx if ENV.compiler == :clang

    # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
    scons "STRIP=0", "SKIPUTILS=all", "makensis"

    if build.stable?
      bin.install "build/release/makensis/makensis"
    else
      bin.install "build/urelease/makensis/makensis"
    end

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
