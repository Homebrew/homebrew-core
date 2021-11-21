class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v2.8.0.tar.gz"
  sha256 "2dabc75446a0e2e970952d325f930853a51a9b4d1868c8135f05552a4ae04d39"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a0e3470019ae0aa86ed9643d0e2c7ef495d59706b90c3b42507eafd6d1bffe74"
    sha256 cellar: :any, arm64_big_sur:  "b24fc8e15d0b9ac94b421eba9dec5249440a2f44a673d5bf81cbee6ff1d356e4"
    sha256 cellar: :any, monterey:       "81d556273a02971789a18854d6435a2629ab2985966f6f3f13707468618a07dd"
    sha256 cellar: :any, big_sur:        "13f2bfec1ce74a5e9d650a8b46cea4b3d9232aff4cb8fd57ec265a312d6a340d"
    sha256 cellar: :any, catalina:       "b6ed14e7d54a1666f84a90624c597b28e649019d6aa6e7cad20ddd8449e9837e"
    sha256 cellar: :any, mojave:         "704e28f5998d58975baa97d28029623440b3fe4e060d91035f9230ccd5390e09"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "embree"
  depends_on macos: :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/v1.8.0.tar.gz"
    sha256 "f037c15f7049610ef8bca37500b2ab00775af60ebbb9d491ba5fc2e5c04a7794"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/v1.1.0.tar.gz"
    sha256 "d193c75a2c57acd764649215b244c432694a0169da374a9d769a81b02a9132e9"
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
