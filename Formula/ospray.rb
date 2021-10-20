class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v2.7.1.tar.gz"
  sha256 "4e7bd8145e19541c04f5d949305f19a894d85a827f567d66ae2eb11a760a5ace"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b24fc8e15d0b9ac94b421eba9dec5249440a2f44a673d5bf81cbee6ff1d356e4"
    sha256 cellar: :any, big_sur:       "13f2bfec1ce74a5e9d650a8b46cea4b3d9232aff4cb8fd57ec265a312d6a340d"
    sha256 cellar: :any, catalina:      "b6ed14e7d54a1666f84a90624c597b28e649019d6aa6e7cad20ddd8449e9837e"
    sha256 cellar: :any, mojave:        "704e28f5998d58975baa97d28029623440b3fe4e060d91035f9230ccd5390e09"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "embree"
  depends_on macos: :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/v1.7.0.tar.gz"
    sha256 "b24d063541ccbfd69e6d77485b509d1bbffd9744e735dbd9bd8647eb8751c5b7"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/v1.0.1.tar.gz"
    sha256 "55a7c2b1dcf4641b523ae999e3c1cded305814067d6145cc8911e70a3e956ba6"
  end

  def install
    resources.each do |r|
      r.stage do
        mkdir "build" do
          system "cmake", "..", *std_cmake_args,
                                "-DCMAKE_INSTALL_NAME_DIR=#{lib}",
                                "-DBUILD_EXAMPLES=OFF"
          system "make"
          system "make", "install"
        end
      end
    end

    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DOSPRAY_ENABLE_APPS=OFF
      -DOSPRAY_ENABLE_TESTING=OFF
      -DOSPRAY_ENABLE_TUTORIALS=OFF
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <ospray/ospray.h>
      int main(int argc, const char **argv) {
        OSPError error = ospInit(&argc, argv);
        assert(error == OSP_NO_ERROR);
        ospShutdown();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lospray"
    system "./a.out"
  end
end
