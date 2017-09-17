class Insighttoolkit < Formula
  desc "Toolkit for performing registration and segmentation"
  homepage "https://www.itk.org"
  url "https://downloads.sourceforge.net/project/itk/itk/4.12/InsightToolkit-4.12.2.tar.gz"
  sha256 "8ba2183111723c4405af80724c60d07484c2bff8120ee4cef543bb726d07855e"
  head "https://itk.org/ITK.git"

  option "without-python", "Build without python2 support"

  depends_on "cmake" => :build
  depends_on :python3 => :optional
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on "gdcm"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "opencv"

  if build.with? "python3"
    depends_on "vtk" => ["with-python3", "without-python"]
  elsif build.with? "python"
    depends_on "vtk" => ["with-python"]
  else
    depends_on "vtk"
  end

  needs :cxx11

  def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
      -DITK_USE_64BITS_IDS=ON
      -DVCL_INCLUDE_CXX_0X=ON
      -DITK_USE_STRICT_CONCEPT_CHECKING=ON
      -DITK_USE_SYSTEM_ZLIB=ON
      -DITK_USE_SYSTEM_EXPAT=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DModule_SCIFIO=ON
      -DModule_ITKVideoBridgeOpenCV=ON
      -DITKV3_COMPATIBILITY=OFF
      -DITK_USE_SYSTEM_HDF5=ON
      -DITK_USE_SYSTEM_JPEG=ON
      -DITK_USE_SYSTEM_PNG=ON
      -DITK_USE_SYSTEM_TIFF=ON
      -DITK_USE_SYSTEM_GDCM=ON
      -DITK_LEGACY_REMOVE=ON
      -DModule_ITKLevelSetsv4Visualization=ON
      -DModule_ITKReview=ON
      -DModule_ITKVtkGlue=ON
      -DITK_USE_GPU=ON
    ]
    args << ".."

    mkdir "build" do
      if build.with?("python") || build.with?("python3")
        python_executable = `which python`.strip if build.with? "python"
        python_executable = `which python3`.strip if build.with? "python3"

        python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
        python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
        python_version = "python" + `#{python_executable} -c 'import sys;print(sys.version[:3])'`.chomp

        args << "-DITK_WRAP_PYTHON=ON"
        args << "-DPYTHON_EXECUTABLE='#{python_executable}'"
        args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"
        # CMake picks up the system's python dylib, even if we have a brewed one.
        if File.exist? "#{python_prefix}/Python"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.a'"
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.dylib'"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.dylib'"
        else
          odie "No libpythonX.Y.{dylib|a} file found!"
        end
      end
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<-EOS
      #include "itkImage.h"

      int main(int argc, char* argv[])
      {
        typedef itk::Image< unsigned short, 3 > ImageType;
        ImageType::Pointer image = ImageType::New();
        image->Update();

        return EXIT_SUCCESS;
      }
    EOS

    v=version.to_s.split(".")[0..1].join(".")
    # Build step
    system ENV.cxx, "-isystem", "#{include}/ITK-#{v}", "-o", "test.cxx.o", "-c", "test.cxx"
    # Linking step
    system ENV.cxx, "test.cxx.o", "-o", "test",
                    "#{lib}/libITKCommon-#{v}.1.dylib",
                    "#{lib}/libITKVNLInstantiation-#{v}.1.dylib",
                    "#{lib}/libitkvnl_algo-#{v}.1.dylib",
                    "#{lib}/libitkvnl-#{v}.1.dylib"
    system "./test"
    system "python", "-c", "import itk;itk.Image[itk.UC, 2]()"
  end
end
