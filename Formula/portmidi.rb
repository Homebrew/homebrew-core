class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://sourceforge.net/projects/portmedia/"
  url "https://downloads.sourceforge.net/project/portmedia/portmidi/217/portmidi-src-217.zip"
  sha256 "08e9a892bd80bdb1115213fb72dc29a7bf2ff108b378180586aa65f3cfd42e0f"

  bottle do
    cellar :any
    rebuild 2
    sha256 "755cc50ba616dc4b10228a792f63af6e280cc85a641ed19f10df3092e5e65a13" => :sierra
    sha256 "bafccc31f658c6803e95f982564b463dab81402428843393db20283fd78c2821" => :el_capitan
    sha256 "e349d8556d5699fc3a1599917f8f575c76cd43f437b8371cd8d003ef7a875810" => :yosemite
  end

  option "with-java", "Build Java-based app and bindings."

  deprecated_option "with-python" => "with-cython"

  depends_on "cmake" => :build
  depends_on "cython" => [:build, :optional]
  depends_on :java => :optional

  # Avoid that the Makefile.osx builds the java app and fails because: fatal error: 'jni.h' file not found
  # Since 217 the Makefile.osx includes pm_common/CMakeLists.txt wich builds the Java app
  patch :DATA if build.without? "java"

  def install
    inreplace "pm_mac/Makefile.osx", "PF=/usr/local", "PF=#{prefix}"

    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath

    # Fix outdated SYSROOT to avoid:
    # No rule to make target `/Developer/SDKs/MacOSX10.5.sdk/...'
    inreplace "pm_common/CMakeLists.txt",
              "set(CMAKE_OSX_SYSROOT /Developer/SDKs/MacOSX10.5.sdk CACHE",
              "set(CMAKE_OSX_SYSROOT /#{MacOS.sdk_path} CACHE"

    system "make", "-f", "pm_mac/Makefile.osx"
    system "make", "-f", "pm_mac/Makefile.osx", "install"

    if build.with? "cython"
      cd "pm_python" do
        # There is no longer a CHANGES.txt or TODO.txt.
        inreplace "setup.py" do |s|
          s.gsub! "CHANGES = open('CHANGES.txt').read()", 'CHANGES = ""'
          s.gsub! "TODO = open('TODO.txt').read()", 'TODO = ""'
        end
        # Provide correct dirs (that point into the Cellar)
        ENV.append "CFLAGS", "-I#{include}"
        ENV.append "LDFLAGS", "-L#{lib}"

        ENV.prepend_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python2.7/site-packages"
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end
  end
end

__END__
diff --git a/pm_common/CMakeLists.txt b/pm_common/CMakeLists.txt
index e171047..b010c35 100644
--- a/pm_common/CMakeLists.txt
+++ b/pm_common/CMakeLists.txt
@@ -112,14 +112,9 @@ target_link_libraries(portmidi-static ${PM_NEEDED_LIBS})
 # define the jni library
 include_directories(${JAVA_INCLUDE_PATHS})

-set(JNISRC ${LIBSRC} ../pm_java/pmjni/pmjni.c)
-add_library(pmjni SHARED ${JNISRC})
-target_link_libraries(pmjni ${JNI_EXTRA_LIBS})
-set_target_properties(pmjni PROPERTIES EXECUTABLE_EXTENSION "jnilib")
-
 # install the libraries (Linux and Mac OS X command line)
 if(UNIX)
-  INSTALL(TARGETS portmidi-static pmjni
+  INSTALL(TARGETS portmidi-static
     LIBRARY DESTINATION /usr/local/lib
     ARCHIVE DESTINATION /usr/local/lib)
 # .h files installed by pm_dylib/CMakeLists.txt, so don't need them here
