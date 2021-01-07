class Gaudi < Formula
  desc "Provides necessary interfaces and services for building HEP exp frameworks"
  homepage "https://gaudi.web.cern.ch/gaudi/"
  url "https://gitlab.cern.ch/gaudi/Gaudi/-/archive/v35r0/Gaudi-v35r0.tar.gz"
  sha256 "c01b822f9592a7bf875b9997cbeb3c94dea97cb13d523c12649dbbf5d69b5fa6"
  license "Apache-2.0"
  head "https://gitlab.cern.ch/gaudi/Gaudi.git"

  depends_on "cmake" => :build
  depends_on "aida-header"
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "clhep"
  depends_on "cpp-gsl"
  depends_on "cppunit"
  depends_on "doxygen"
  depends_on "fmt"
  depends_on "gperftools"
  depends_on "heppdt2"
  depends_on "jemalloc"
  depends_on "nlohmann-json"
  depends_on "python@3.9"
  depends_on "range-v3"
  depends_on "root"
  depends_on "tbb"
  depends_on "xerces-c"

  def install
    # Fix cmake issue with Foundation framework. Git issue here https://gitlab.cern.ch/gaudi/Gaudi/-/issues/158 and associated MR https://gitlab.cern.ch/gaudi/Gaudi/-/merge_requests/1158

    inreplace "GaudiKernel/CMakeLists.txt", /target_link_libraries\(GaudiKernel PUBLIC Foundation\)/,
              "target_link_libraries(GaudiKernel PUBLIC ${Foundation_FRAMEWORK})"

    system "cmake", ".", "-DBoost_NO_BOOST_CMAKE=ON", "-DGAUDI_USE_UNWIND=OFF", "-DRANGEV3_INCLUDE_DIR=#{Formula["range-v3"].opt_include}", *std_cmake_args
    system "make"

    # Remove the .db extension otherwise, the installation will crash
    File.rename("Gaudi.confdb2.db", "Gaudi.confdb2")

    system "make", "install"
  end

  test do
    system "#{bin}/test_GaudiTimer"
  end
end
