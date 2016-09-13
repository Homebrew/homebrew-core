class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://sourceforge.net/projects/portmedia/"
  url "https://downloads.sourceforge.net/project/portmedia/portmidi/217/portmidi-src-217.zip"
  sha256 "08e9a892bd80bdb1115213fb72dc29a7bf2ff108b378180586aa65f3cfd42e0f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0753ebe02a1713ebc6d090cec9be0bb3c01cf4fec430aa6eabe63b483f954e7f" => :sierra
    sha256 "5320b13b677108342e5153f86f3472a5dc988cd616e804bbe20ea19a237602b0" => :el_capitan
    sha256 "091871a9be11e7af35cd455bb55e8020ce911ac768ac0569fa489d7b34fd715e" => :yosemite
    sha256 "c950ba2eed6221f1734ab05fe44c263eedbabd7510bec2de3333c61984bfb87c" => :mavericks
  end

  option "with-java", "Build Java-based app and bindings."

  depends_on "cmake" => :build
  depends_on :python => :optional
  depends_on :java => :optional

  # Avoid that the Makefile.osx builds the java app and fails because: fatal error: 'jni.h' file not found
  # Since 217 the Makefile.osx includes pm_common/CMakeLists.txt wich builds the Java app
  patch :DATA if build.without? "java"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/c6/fe/97319581905de40f1be7015a0ea1bd336a756f6249914b148a17eefa75dc/Cython-0.24.1.tar.gz"
    sha256 "84808fda00508757928e1feadcf41c9f78e9a9b7167b6649ab0933b76f75e7b9"
  end

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

    if build.with? "python"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"cython/lib/python2.7/site-packages"
      resource("Cython").stage do
        system "python", *Language::Python.setup_install_args(buildpath/"cython")
      end
      ENV.prepend_path "PATH", buildpath/"cython/bin"

      cd "pm_python" do
        # There is no longer a CHANGES.txt or TODO.txt.
        inreplace "setup.py" do |s|
          s.gsub! "CHANGES = open('CHANGES.txt').read()", 'CHANGES = ""'
          s.gsub! "TODO = open('TODO.txt').read()", 'TODO = ""'
        end
        # Provide correct dirs (that point into the Cellar)
        ENV.append "CFLAGS", "-I#{include}"
        ENV.append "LDFLAGS", "-L#{lib}"
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
