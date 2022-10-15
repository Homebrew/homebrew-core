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
    sha256 cellar: :any, arm64_monterey: "910cb04a63aac6461bfb1d72d134e16149b8b6e9ae6905a3fed082b4f41928af"
    sha256 cellar: :any, arm64_big_sur:  "ffe2e20e8f228b0fdb5fc9c44dd56b9ae84b47009ec2fe27acd22cba75b07a97"
    sha256 cellar: :any, monterey:       "a7074debfc72bb6446bb67591dd78d432d509a2226c808d54586a6413b9fb589"
    sha256 cellar: :any, big_sur:        "a5679578a55d37c982491bde0be1337a0ea6c4151e75981cf7a9e14a6ee52cc9"
    sha256 cellar: :any, catalina:       "4bba841c5604a541c6821132c79b5e035daffb05d2d11506d9ebd33ff97613f1"
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
