class FlexiblasOpenblas < Formula
  desc "OpenBLAS runtime backend for FlexiBLAS"
  homepage "https://www.mpi-magdeburg.mpg.de/projects/flexiblas"
  url "https://csc.mpi-magdeburg.mpg.de/mpcsc/software/flexiblas/flexiblas-3.4.4.tar.xz"
  sha256 "f3b4db7175f00434b1ad1464c0fd004f9b9ddf4ef8d78de5a75382a1f73a75dd"
  license "LGPL-3.0-or-later"
  head "https://gitlab.mpi-magdeburg.mpg.de/software/flexiblas-release.git", branch: "master"

  livecheck do
    formula "flexiblas"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran (needed during CMake generate)
  depends_on "openblas"

  def install
    # Remove license for NETLIB which is part of main `flexiblas` formula
    rm "COPYING.NETLIB"

    args = %w[
      -DEXAMPLES=OFF
      -DTESTS=OFF
      -DAPPLE=OFF
      -DATLAS=OFF
      -DBlisSerial=OFF
      -DBlisPThread=OFF
      -DBlisOpenMP=OFF
      -DMklSerial=OFF
      -DMklOpenMP=OFF
      -DMklTBB=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "flexiblas_openblasopenmp"
    (lib/"flexiblas").install Dir["build/lib/libflexiblas_openblas*"]
    (prefix/"etc/flexiblasrc.d").install Dir["build/flexiblasrc.d/OpenBLAS*.conf"]
  end

  test do
    # Main test is done in `flexiblas` so only check shared library exists
    assert_predicate lib/shared_library("flexiblas/libflexiblas_openblasopenmp"), :exist?
  end
end
