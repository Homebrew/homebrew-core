class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v2.4.0.tar.gz"
  sha256 "5eaf7409b08147cbeaf087dbf4b3887c15ffeeaa9cfd16dae3ee85504d9014c2"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "ac654983632917fb62802c62096b397dc7c9408b0c0367d3ae8d09ce63b64704" => :big_sur
    sha256 "6bcf5f7e81d8a79c6224061fb144b2219af0ffba26578af6e2abbc31fbc7165d" => :catalina
    sha256 "be56b0fe9a42a9c99e7ec57b152e58ed67f2a6ab81bcaa546bfbb84262d34984" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "embree"
  depends_on macos: :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/v1.5.1.tar.gz"
    sha256 "27dc42796aaa4ea4a6322f14ad64a46e83f42724c20c0f7b61d069ac91310295"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/v0.11.0.tar.gz"
    sha256 "2854f270b34d310b9a9d47deb00cc6897038707fac75b427dbf81602ee1b2136"
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
