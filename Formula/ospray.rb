class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v2.1.0.tar.gz"
  sha256 "ab38106beac3868cb39ef35f5564d51277641ecd982afc45e463aada6a124502"
  head "https://github.com/ospray/ospray.git"

  bottle do
    cellar :any
    sha256 "b9b5016940568986207bc383505a8e8742252bd7c42e9f072647bdecea849865" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "embree"
  depends_on :macos => :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "ospcommon" do
    url "https://github.com/ospray/ospcommon/archive/v1.3.0.tar.gz"
    sha256 "23f17fd930e63af9dd0f76ea3505e5d11f91a138b8e8bdec50efd51162544042"
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
