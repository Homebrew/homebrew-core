class Paraview < Formula
  desc "Multi-platform data analysis and visualization application"
  homepage "https://www.paraview.org/"
  url "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.4&type=source&os=Sources&downloadFile=ParaView-v5.4.0.tar.gz"
  sha256 "390d0f5dc66bf432e202a39b1f34193af4bf8aad2355338fa5e2778ea07a80e4"
  revision 4

  head "https://gitlab.kitware.com/paraview/paraview.git"

  bottle :disable, "needs to be rebuilt with latest boost"

  option "with-osmesa", "Build with off-sceen mesa(osmesa)"

  depends_on "cmake" => :build

  depends_on "boost" => :recommended
  depends_on "ffmpeg" => :recommended
  depends_on "qt" => :recommended
  depends_on "open-mpi" => :optional
  depends_on "mpich" => :optional
  depends_on "python" => :recommended

  depends_on "freetype"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "fontconfig"
  depends_on "libpng"
  depends_on "linuxbrew/xorg/mesa" if OS.linux?
  depends_on "linuxbrew/xorg/glu" if OS.linux? && (build.without? "osmesa")

  def install
    dylib = OS.mac? ? "dylib" : "so"

    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DMACOSX_APP_INSTALL_PREFIX=#{prefix}
      -DPARAVIEW_DO_UNIX_STYLE_INSTALLS:BOOL=OFF
      -DPARAVIEW_QT_VERSION=5
      -DVTK_USE_SYSTEM_EXPAT:BOOL=ON
      -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON
      -DVTK_USE_SYSTEM_HDF5:BOOL=ON
      -DVTK_USE_SYSTEM_JPEG:BOOL=ON
      -DVTK_USE_SYSTEM_LIBXML2:BOOL=ON
      -DVTK_USE_SYSTEM_PNG:BOOL=ON
      -DVTK_USE_SYSTEM_TIFF:BOOL=ON
      -DVTK_USE_SYSTEM_ZLIB:BOOL=ON
      -DVTK_USE_SYSTEM_ZLIB:BOOL=NETCDF
    ]

    if build.with? "osmesa"
      args = std_cmake_args + %W[
        -DVTK_USE_X=OFF
        -DOPENGL_INCLUDE_DIR=IGNORE
        -DOPENGL_xmesa_INCLUDE_DIR=IGNORE
        -DOPENGL_gl_LIBRARY=IGNORE
        -DOSMESA_INCLUDE_DIR=#{Formula["mesa"].opt_include}
        -DOSMESA_LIBRARY=#{Formula["mesa"].opt_lib}/libOSMesa.so
        -DVTK_OPENGL_HAS_OSMESA=ON
        -DVTK_USE_OFFSCREEN=OFF
      ]
    end
 
    args << "-DPARAVIEW_BUILD_QT_GUI:BOOL=OFF" if build.without? "qt"
    args << "-DPARAVIEW_USE_MPI:BOOL=ON" if build.with? "open-mpi"
    args << "-DPARAVIEW_USE_MPI:BOOL=ON" if build.with? "mpich"
    args << "-DPARAVIEW_ENABLE_FFMPEG:BOOL=ON" if build.with? "ffmpeg"
    args << "-DPARAVIEW_USE_VISITBRIDGE:BOOL=ON" if build.with? "boost"
    args << "-DPARAVIEW_ENABLE_PYTHON:BOOL=" + ((build.with? "python") ? "ON" : "OFF")

    mkdir "build" do
      # Python3 support is being worked on, see https://gitlab.kitware.com/paraview/paraview/issues/16818
      if build.with? "python"
        python_executable = Formula["python@2"].opt_bin/"python2"
        python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
        python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
        python_version = "python" + `#{python_executable} -c 'import sys;print(sys.version[:3])'`.chomp

        args << "-DPYTHON_EXECUTABLE='#{python_executable}'"
        args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"

        # CMake picks up the system's python dylib, even if we have a brewed one.
        if File.exist? "#{python_prefix}/Python"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.a'"
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.#{dylib}"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.#{dylib}'"
        elsif File.exist? "#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.#{dylib}"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.so'"
        else
          odie "No libpythonX.Y.{dylib|so|a} file found!"
        end
      end
      args << ".."

      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    assert_match "paraview version #{version}", shell_output("#{prefix}/paraview.app/Contents/MacOS/paraview --version 2>&1", 0)
  end
end
