class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v2.1.1.tar.gz"
  sha256 "342061794dd0851f1580e53256c8e506b4e0950dd67209e1df573694c4d85e6f"
  head "https://github.com/ospray/ospray.git"

  bottle do
    cellar :any
    sha256 "de27725e3305a8f9967a087451a5dac1dd78f2a9e79ae64a474234ae683c0b69" => :catalina
    sha256 "b33ef0dc21b85759bffab6233bb76e2fbf35c2a194a99bed7a175fe8eb85a153" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "embree"
  depends_on :macos => :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "ospcommon" do
    url "https://github.com/ospray/ospcommon/archive/v1.3.1.tar.gz"
    sha256 "1c043c4a09e68fb7319db61f28a5830fc09f1457b24155a42b5f7c6421bcca73"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/v0.9.0.tar.gz"
    sha256 "06aa82c8c3ff68ab93fb8240f4881a1bc238b3de681812e71145f8a1629d3fee"
  end

  def install
    resources.each do |r|
      r.stage do
        mkdir "build" do
          system "cmake", "..", *std_cmake_args,
                                "-DBUILD_EXAMPLES=OFF",
                                "-DBUILD_TESTING=OFF"
          system "make"
          system "make", "install"
        end
      end
    end

    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
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
