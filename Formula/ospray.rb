class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v2.10.0.tar.gz"
  sha256 "bd478284f48d2cb775fc41a2855a9d9f5ea16c861abda0f8dc94e02ea7189cb8"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f606fa09b7f0d87d95bec188727b7bd058373e726527d5d5a06a3dff132c160e"
    sha256 cellar: :any, arm64_big_sur:  "474b623582aa113ad7fce11aaf505bae0acf9a2a47e92560e94fd7ab2b8803c2"
    sha256 cellar: :any, monterey:       "394583d69bea8efcd6eaa991b1a8c31e1b51bd691e7634bd7e5dace7a17680a8"
    sha256 cellar: :any, big_sur:        "6bb8ebb044c15a0dc5cad82c3f97bff0c7d36537bb46c7fc326e874e5d5fe8fd"
    sha256 cellar: :any, catalina:       "91a644692ca74faa2a124c6a32c6d09a1fa0c57dd86043c2bb438722b8b556b4"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "embree"
  depends_on macos: :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/v1.10.0.tar.gz"
    sha256 "57a33ce499a7fc5a5aaffa39ec7597115cf69ed4ff773546b5b71ff475ee4730"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/v1.3.0.tar.gz"
    sha256 "c6d4d40e6d232839c278b53dee1e7bd3bd239c3ccac33f49b465fc65a0692be9"
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
