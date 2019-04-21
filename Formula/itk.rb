class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://www.itk.org"
  url "https://downloads.sourceforge.net/project/itk/itk/4.13/InsightToolkit-4.13.2.tar.gz"
  sha256 "d8760b279de20497c432e7cdf97ed349277da1ae435be1f6f0f00fbe8d4938c1"
  head "git://itk.org/ITK.git"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdcm"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "vtk"

  # Patch needed to install MINC's cmake files into #{lib}/cmake not #{lib}
  # PR Submitted to ITK upstream: https://github.com/InsightSoftwareConsortium/ITK/pull/754
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/itk/4.13.2-MINC-cmake-files-location.patch"
    sha256 "7ec6a55e83109332d636298e7339793ec338969211533467ff0fbfb7c1c27883"
  end

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DITK_USE_64BITS_IDS=ON
      -DITK_USE_STRICT_CONCEPT_CHECKING=ON
      -DITK_USE_SYSTEM_ZLIB=ON
      -DITK_USE_SYSTEM_EXPAT=ON
      -DModule_SCIFIO=ON
      -DITKV3_COMPATIBILITY:BOOL=OFF
      -DITK_USE_SYSTEM_FFTW=ON
      -DITK_USE_FFTWF=ON
      -DITK_USE_FFTWD=ON
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

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<-EOS
      #include "itkImage.h"
      int main(int argc, char* argv[])
      {
        typedef itk::Image<unsigned short, 3> ImageType;
        ImageType::Pointer image = ImageType::New();
        image->Update();
        return EXIT_SUCCESS;
      }
    EOS

    v = version.to_s.split(".")[0..1].join(".")
    # Build step
    system ENV.cxx, "-isystem", "#{include}/ITK-#{v}", "-o", "test.cxx.o", "-c", "test.cxx"
    # Linking step
    system ENV.cxx, "test.cxx.o", "-o", "test",
                    "#{lib}/libITKCommon-#{v}.1.dylib",
                    "#{lib}/libITKVNLInstantiation-#{v}.1.dylib",
                    "#{lib}/libitkvnl_algo-#{v}.1.dylib",
                    "#{lib}/libitkvnl-#{v}.1.dylib"
    system "./test"
  end
end
