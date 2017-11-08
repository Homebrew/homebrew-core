class Ogre < Formula
  desc "Scene-oriented, flexible 3D engine"
  homepage "http://www.ogre3d.org/"
  url "https://github.com/OGRECave/ogre/archive/v1.10.9.tar.gz"
  sha256 "85ba2cc6a35c67ff93a9a498af9f8f3113fd3a16e7cc43c18b9769d8bf1e9101"

  option "with-java-component", "Build with java component"
  option "with-python-component", "Build with python component"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost" => [:optional, :cxx11]
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "libpng"
  depends_on "libzzip"
  depends_on "openexr"
  depends_on "sdl"
  depends_on "sdl2"

  if build.with?("java-component") || build.with?("python-component")
    depends_on "swig"
    depends_on :java if build.with? "java-component"
    depends_on :python if build.with? "python-component"
  end

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
    args += %w[-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
               -DOGRE_FULL_RPATH=TRUE
               -DOGRE_BUILD_DEPENDENCIES=FALSE
               -DOGRE_INSTALL_DEPENDENCIES=FALSE
               -DOGRE_COPY_DEPENDENCIES=FALSE
               -DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=OFF
               -DOGRE_BUILD_SAMPLES=OFF
               -DOGRE_BUILD_PLUGIN_CG=OFF
               -DOGRE_BUILD_LIBS_AS_FRAMEWORKS=OFF]
    # "std" meands using c++11.
    args << "-DOGRE_CONFIG_THREAD_PROVIDER=" + (build.with?("boost") ? "boost" : "std")

    # See https://github.com/OGRECave/ogre/issues/563
    if build.with?("python-component")
      inreplace "Components/Python/CMakeLists.txt", "set(CMAKE_SWIG_FLAGS -w401,314 -builtin)",
                "set(CMAKE_SWIG_FLAGS -w401,314 -builtin -D_LIBCPP_VERSION)"
    else
      args << "-DOGRE_BUILD_COMPONENT_PYTHON=OFF"
    end
    if build.with?("java-component")
      inreplace "Components/Java/CMakeLists.txt", "set(CMAKE_SWIG_FLAGS -w401,314 -package org.Ogre)",
                "set(CMAKE_SWIG_FLAGS -w401,314 -package org.Ogre -D_LIBCPP_VERSION)"
    else
      args << "-DOGRE_BUILD_COMPONENT_JAVA=OFF"
    end

    system "cmake", ".", *args
    system "make", "install"
    lib.install "java/libs/libOgreJNI.jnilib" if build.with? "java-component"
    MachO::Tools.change_install_name("#{lib}/OGRE/Plugin_OctreeZone.#{version}.dylib",
                                     "@rpath/Plugin_PCZSceneManager.#{version}.dylib", "#{lib}/OGRE/Plugin_PCZSceneManager.#{version}.dylib")
  end

  def caveats
    if build.with? "python-component" then <<~EOS
      You might add "#{HOMEBREW_PREFIX}/lib/python2.7/dist-packages" to PYTHONPATH as following.

        export PYTHONPATH="#{HOMEBREW_PREFIX}/lib/python2.7/dist-packages:$PYTHONPATH"

      EOS
    end
  end

  test do
    (testpath/"test.mesh.xml").write <<-EOS
      <mesh>
        <submeshes>
          <submesh material="BaseWhite" usesharedvertices="false" use32bitindexes="false" operationtype="triangle_list">
            <faces count="1">
              <face v1="0" v2="1" v3="2" />
            </faces>
            <geometry vertexcount="3">
              <vertexbuffer positions="true" normals="false" texture_coords="0">
                <vertex>
                  <position x="-50" y="-50" z="50" />
                </vertex>
                <vertex>
                  <position x="-50" y="-50" z="-50" />
                </vertex>
                <vertex>
                  <position x="50" y="-50" z="-50" />
                </vertex>
              </vertexbuffer>
            </geometry>
          </submesh>
        </submeshes>
        <submeshnames>
          <submeshname name="submesh0" index="0" />
        </submeshnames>
      </mesh>
      EOS
    system "#{bin}/OgreXMLConverter", "test.mesh.xml"
    system "du", "-h", "./test.mesh"
  end
end
