class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v2.2.0.tar.gz"
  sha256 "7078cc7c7a6e709589f8cb15a150947bb1b93f00d08f8a2ef3f5e368d57a3797"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git"

  bottle do
    cellar :any
    sha256 "f6b816e4ce29195586af8305a27bcb49f366bf08cc761ee85deb8eb69165f897" => :catalina
    sha256 "044aa16b8c07c9188a242d12f1ca809844bfaf2606777427dfd761d611135642" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "embree"
  depends_on macos: :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/v1.4.2.tar.gz"
    sha256 "2d1c0046cf583d3040fc9bb3b8ddcb1a2262d3f48aebd0973e6bd6cabb487f9e"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/v0.10.0.tar.gz"
    sha256 "b75caabd5e0211e8c29dd9bd04a74c9ed30a1a72413c486206144c25fd31afff"
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
