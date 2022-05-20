class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v2.9.0.tar.gz"
  sha256 "0145e09c3618fb8152a32d5f5cff819eb065d90975ee4e35400d2db9eb9f6398"
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
    url "https://github.com/ospray/rkcommon/archive/v1.9.0.tar.gz"
    sha256 "b68aa02ef44c9e35c168f826a14802bb5cc6a9d769ba4b64b2c54f347a14aa53"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/v1.2.0.tar.gz"
    sha256 "dc468c2f0a359aaa946e04a01c2a6634081f7b6ce31b3c212c74bf7b4b0c9ec2"
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
