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
  depends_on "cppunit"
  depends_on "doxygen"
  depends_on "gperftools"
  depends_on "heppdt2"
  depends_on "jemalloc"
  depends_on "python@3.9"
  depends_on "root"
  depends_on "tbb"
  depends_on "xerces-c"

  def install
    # Fix cmake issue with Foundation framework

    inreplace "GaudiKernel/CMakeLists.txt", /target_link_libraries\(GaudiKernel PUBLIC Foundation\)/,
                        "target_link_libraries(GaudiKernel PUBLIC ${Foundation_FRAMEWORK})"
    
    system "cmake", ".", "-DBoost_NO_BOOST_CMAKE=ON", "-DGAUDI_USE_UNWIND=OFF", *std_cmake_args
    system "make"

    # Remove the .db extension otherwise, the installation will crash
    File.rename("Gaudi.confdb2.db", "Gaudi.confdb2")

    system "make", "install"
  end

  test do
    system "#{bin}/test_GAUDI-905"
    system "#{bin}/test_GAUDI-973"
    system "#{bin}/test_PropertyHolder"
    system "#{bin}/test_Property"
    system "#{bin}/test_WeakPropertyRef"
    system "#{bin}/test_StatusCode"
    system "#{bin}/test_EventIDBase"
    system "#{bin}/test_EventIDRange"
    system "#{bin}/test_SystemTypeinfoName"
    system "#{bin}/test_SystemCmdLineArgs"
    system "#{bin}/test_compose"
    system "#{bin}/test_reverse"
    system "#{bin}/test_Counters"
    system "#{bin}/test_MonotonicArena"
    system "#{bin}/test_GaudiTimer"
    system "#{bin}/test_SerializeSTL"
    system "#{bin}/test_AnyDataObject"
    system "#{bin}/test_DataHandleVector"
    system "#{bin}/test_GaudiTime"
    system "#{bin}/test_LockedHandle"
  end
end
