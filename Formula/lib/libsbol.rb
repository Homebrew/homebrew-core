class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "c85de13b35dec40c920ff8a848a91c86af6f7c7ee77ed3c750f414bbbbb53924"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b09a89a225eb9340d711c26788bc531b1ca5e3f37fc7be1dcc1419124210fd7f"
    sha256 cellar: :any,                 arm64_sonoma:  "751b7e6d933a55e321f83d57b1bd7a9035530bba45ff8e30e497ff52a539d359"
    sha256 cellar: :any,                 arm64_ventura: "82dca670a8ca74e4f974727a4b895a2664dbf74601a79e59c657fa1fbfd8f546"
    sha256 cellar: :any,                 sonoma:        "ee16f7b504002ebc4845c479d3b6abf3858deabc1ff9f0671b100f7a58c85af4"
    sha256 cellar: :any,                 ventura:       "34f6fef82f97d5be5834994ce870e42a643b3334e9b4c0539b7a922edcdc7e6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6c5e5965c77dd8dc497af89ddbc8fea4542ccd551c57422967d19a42a8b87e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ef4f70407b40a1c4791f08309df2075a15cac5a038f0085ecfa23ff0d460258"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jsoncpp"
  depends_on "raptor"
  depends_on "rasqal"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  def install
    # upstream issue: https://github.com/SynBioDex/libSBOL/issues/215
    inreplace "source/CMakeLists.txt", "measure.h", "measurement.h"

    args = std_cmake_args
    args << "-DSBOL_BUILD_SHARED=TRUE"
    args << "-DRAPTOR_INCLUDE_DIR=#{Formula["raptor"].opt_include}/raptor2"
    args << "-DRASQAL_INCLUDE_DIR=#{Formula["rasqal"].opt_include}"

    if OS.mac? && (sdk = MacOS.sdk_path_if_needed)
      args << "-DCURL_LIBRARY=#{sdk}/usr/lib/libcurl.tbd"
      args << "-DLIBXSLT_INCLUDE_DIR=#{sdk}/usr/include/"
      args << "-DLIBXSLT_LIBRARIES=#{sdk}/usr/lib/libxslt.tbd"
    end

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "sbol/sbol.h"

      using namespace sbol;

      int main() {
        Document& doc = *new Document();
        doc.write("test.xml");
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11",
                    "-I/System/Library/Frameworks/Python.framework/Headers",
                    "-I#{Formula["raptor"].opt_include}/raptor2",
                    "-I#{include}", "-L#{lib}",
                    "-L#{Formula["jsoncpp"].opt_lib}",
                    "-L#{Formula["raptor"].opt_lib}",
                    "-ljsoncpp", "-lcurl", "-lraptor2", "-lsbol"
    system "./test"
  end
end
