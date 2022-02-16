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
    sha256 cellar: :any, arm64_monterey: "27d5cd84fdcb61aed73615c0b712f429a0f1b7df85d40315cb590ace93114d9f"
    sha256 cellar: :any, arm64_big_sur:  "56e3d6f2fb3397da3e5851734d249e27e0d3a977a18bd56efac86450a187e645"
    sha256 cellar: :any, monterey:       "5b04ca98dc320b067be01c21ee939bd00e41004d38875f08931170e26208d61e"
    sha256 cellar: :any, big_sur:        "e7aeb214fa4838ade69c27e42da80b52864fab318463096cd0e616e0699a3123"
    sha256 cellar: :any, catalina:       "e06589b30ff8480d2bab0cc0e4696a16ea20fb10dae9ada2c031995a98dc7e4c"
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
