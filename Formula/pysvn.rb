class Pysvn < Formula
  desc "Python interface to Subversion"
  homepage "http://pysvn.tigris.org/"
  url "http://pysvn.barrys-emacs.org/source_kits/pysvn-1.8.0.tar.gz"
  sha256 "39596f4884ed689cdb5a4e210e421724302a566c7ba756cc4d46bbfeb0c8326b"

  option "without-python", "Build without python2 support"

  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :recommended
  depends_on "openssl"
  depends_on "subversion"

  # Fix configure to respect CPPFLAGS, CXXFLAGS and LDFLAGS
  # http://pysvn.tigris.org/issues/show_bug.cgi?id=206
  patch :DATA

  def install
    if build.without?("python") && build.without?("python3")
      odie "pysvn: at least one of --with-python or --with-python3 must be specified"
    end

    cd "Source" do
      # Replace explicit linking against Python framework with dynamic lookup
      # http://pysvn.tigris.org/issues/show_bug.cgi?id=207
      inreplace "setup_configure.py", "%(PYTHON_FRAMEWORK)s", "-undefined dynamic_lookup"

      i = 0
      Language::Python.each_python(build) do |python, version|
        if i > 0
          # Remove trails of the previous compile
          system "make", "clean"
        end
        system python, "setup.py", "configure"
        system "make"
        (lib/"python#{version}/site-packages/pysvn").install "pysvn/__init__.py", Dir["pysvn/_pysvn*.so"]
        i += 1
      end
    end
  end

  test do
    system "svnadmin", "create", "test"
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "import os, pysvn; pysvn.Client().info2('file://' + os.path.join(os.getcwd(), 'test'))"
    end
  end
end
__END__
diff --git a/Source/setup_configure.py b/Source/setup_configure.py
index afeee2d..1680de1 100644
--- a/Source/setup_configure.py
+++ b/Source/setup_configure.py
@@ -849,8 +849,8 @@ class CompilerGCC(Compiler):
     def __init__( self, setup ):
         Compiler.__init__( self, setup )
 
-        self._addVar( 'CCC',            'g++' )
-        self._addVar( 'CC',             'gcc' )
+        self._addVar( 'CCC',            'g++ $(CPPFLAGS) $(CXXFLAGS)' )
+        self._addVar( 'CC',             'gcc $(CPPFLAGS)' )
 
     def getPythonExtensionFileExt( self ):
         return '.so'
@@ -976,8 +976,8 @@ class MacOsxCompilerGCC(CompilerGCC):
         else:
             arch_options = ''
 
-        self._addVar( 'CCC',            'g++ %s' % (arch_options,) )
-        self._addVar( 'CC',             'gcc %s' % (arch_options,) )
+        self._addVar( 'CCC',            'g++ $(CPPFLAGS) $(CXXFLAGS) %s' % (arch_options,) )
+        self._addVar( 'CC',             'gcc $(CPPFLAGS) %s' % (arch_options,) )
 
         self._find_paths_pycxx_dir = [
                         '../Import/pycxx-%d.%d.%d' % pycxx_version,
@@ -1036,7 +1036,7 @@ class MacOsxCompilerGCC(CompilerGCC):
                                         '-Wall -fPIC -fexceptions -frtti '
                                         '-I. -I%(APR_INC)s -I%(APU_INC)s -I%(SVN_INC)s '
                                         '-D%(DEBUG)s' )
-        self._addVar( 'LDEXE',          '%(CCC)s -g' )
+        self._addVar( 'LDEXE',          '%(CCC)s $(LDFLAGS) -g' )
 
     def setupPySvn( self ):
         self._pysvnModuleSetup()
@@ -1074,7 +1074,7 @@ class MacOsxCompilerGCC(CompilerGCC):
 
         self._addVar( 'CCCFLAGS', ' '.join( py_cflags_list ) )
         self._addVar( 'LDLIBS', ' '.join( py_ld_libs ) )
-        self._addVar( 'LDSHARED',       '%(CCC)s -bundle -g '
+        self._addVar( 'LDSHARED',       '%(CCC)s $(LDFLAGS) -bundle -g '
                                         '-framework System '
                                         '%(PYTHON_FRAMEWORK)s '
                                         '-framework CoreFoundation '
@@ -1144,7 +1144,7 @@ class UnixCompilerGCC(CompilerGCC):
                                         '-Wall -fPIC -fexceptions -frtti '
                                         '-I. -I%(APR_INC)s -I%(APU_INC)s -I%(SVN_INC)s '
                                         '-D%(DEBUG)s' )
-        self._addVar( 'LDEXE',          '%(CCC)s -g' )
+        self._addVar( 'LDEXE',          '%(CCC)s $(LDFLAGS) -g' )
 
     def setupPySvn( self ):
         self._pysvnModuleSetup()
@@ -1176,7 +1176,7 @@ class UnixCompilerGCC(CompilerGCC):
 
         self._addVar( 'CCCFLAGS',   ' '.join( py_cflags_list ) )
         self._addVar( 'LDLIBS',     ' '.join( self._getLdLibs() ) )
-        self._addVar( 'LDSHARED',   '%(CCC)s -shared -g' )
+        self._addVar( 'LDSHARED',   '%(CCC)s $(LDFLAGS) -shared -g' )
 
 #--------------------------------------------------------------------------------
 class LinuxCompilerGCC(UnixCompilerGCC):
