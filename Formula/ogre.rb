class Ogre < Formula
  desc "Scene-oriented, flexible 3D engine"
  homepage "http://www.ogre3d.org/"
  url "https://github.com/OGRECave/ogre/archive/v1.10.9.tar.gz"
  sha256 "85ba2cc6a35c67ff93a9a498af9f8f3113fd3a16e7cc43c18b9769d8bf1e9101"

  option "with-boost-thread", "build with boost-thread-mt"
  needs :cxx11

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost" => "c++11"
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "libpng"
  depends_on "libzzip"
  depends_on "openexr"
  depends_on "sdl"
  depends_on "sdl2"

  def install
    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    ENV.cxx11
    ENV.append "CXXFLAGS", "-std=c++11"
    if ENV.compiler == :clang
      ENV.append "CXXFLAGS", "-stdlib=libc++"
      ENV.append "LINKFLAGS", "-stdlib=libc++"
    end
    # OGRE tends to use "/Library/Frameworks/SDL.framework" if exist. Because OGRE appends "-F/Library/Frameworks".
    ENV.prepend "CPPFLAGS", "-I#{Formula["sdl"].opt_include}/SDL"

    inreplace "CMake/Utils/OgreConfigTargets.cmake", "set(PLATFORM_NAME \"macosx\")", ""
    inreplace "CMake/CMakeLists.txt", "set(OGRE_CMAKE_DIR \"CMake\")", "set(OGRE_CMAKE_DIR \"lib/OGRE/cmake\")"
    inreplace ["Samples/Media/CMakeLists.txt", "CMake/InstallResources.cmake"],
              "set(OGRE_MEDIA_PATH \"Media\")", "set(OGRE_MEDIA_PATH \"share/ogre/Media\")"
    inreplace "CMake/InstallResources.cmake", "set(OGRE_CFG_INSTALL_PATH \"bin\")", "set(OGRE_CFG_INSTALL_PATH \"share/ogre/cfg\")"

    args = std_cmake_args
    args += %W[-DCMAKE_SKIP_BUILD_RPATH=FALSE
               -DOGRE_FULL_RPATH=TRUE
               -DOGRE_LIB_DIRECTORY=#{lib}
               -DOGRE_BUILD_DEPENDENCIES=FALSE
               -DOGRE_INSTALL_DEPENDENCIES=FALSE
               -DOGRE_COPY_DEPENDENCIES=FALSE
               -DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=OFF
               -DOGRE_BUILD_SAMPLES=OFF
               -DOGRE_BUILD_PLUGIN_CG=OFF
               -DOGRE_BUILD_LIBS_AS_FRAMEWORKS=OFF
               -DOGRE_BUILD_COMPONENT_JAVA=OFF
               -DOGRE_BUILD_COMPONENT_PYTHON=OFF]
    # "std" meands using c++11.
    args << "-DOGRE_CONFIG_THREAD_PROVIDER=" + (build.with?("boost-thread") ? "boost" : "std")
    args << "-DOGRE_USE_STD11=ON"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/OgreXMLConverter", "-v"
  end
end
