class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/v2.3.2.tar.gz"
  sha256 "c85de13b35dec40c920ff8a848a91c86af6f7c7ee77ed3c750f414bbbbb53924"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "729d76ef1e1d5e94eafdc91d985e51dfa2d71f5d65c972b64c72c64e136759fb"
    sha256 cellar: :any,                 arm64_monterey: "424c45f889a942cdf2a91db6a0e27fcefed1b6300dfe2715c77971a0bb63ae6f"
    sha256 cellar: :any,                 arm64_big_sur:  "abe3ed20d3307039f2518d0ada34a5410f808cef2cb7d7f48c0b8547b37bce92"
    sha256 cellar: :any,                 ventura:        "e3a3301d2e33f394d3ab874f7f42ce8a155e94e219970f92c70dfd8873314103"
    sha256 cellar: :any,                 monterey:       "1b3317cfc73dc8930c89754110b46f33f32c13950bf4e0606bb7d17618808ec1"
    sha256 cellar: :any,                 big_sur:        "fd852551cf8ecc596eeb82fa82922307d1ea710b96bbe25fd769acb57d6c5db8"
    sha256 cellar: :any,                 catalina:       "fa4fabe7e100011c6a0d48e6286c509bc66680a631e52ae5dd7a2163d732486b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b6876a8bc254eb892a4def5c2d6c1c4d4875407dbf235b607c675aa9b3aefb4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "sbol/sbol.h"

      using namespace sbol;

      int main() {
        Document& doc = *new Document();
        doc.write("test.xml");
        return 0;
      }
    EOS
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
