class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++11"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
    tag:      "v0.31.0",
    revision: "6dd94a16249ae9dd5252c532da6a60cde5194cb7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "52989ba2dfa5bd84d3e46b1dd190a99b01b9fc5a3d8eb24d0f0ff9bc4b54ccdf" => :catalina
    sha256 "226993d75f714a3f1fc25dfb0d735d22c7db9e04237b42c3e98d276629851c80" => :mojave
    sha256 "791ebf1f6f9585872fa2b5dd4230ef73537ce271916fd27e543f1f42afb5772a" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", *std_cmake_args,
                    "-Bbuild/default",
                    "-DBUILD_BACKEND=ON",
                    "-H."
    system "cmake", "--build", "build/default", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mavsdk/mavsdk.h>
      #include <mavsdk/plugins/info/info.h>
      int main() {
          mavsdk::Mavsdk mavsdk;
          mavsdk.version();
          mavsdk::System& system = mavsdk.system();
          auto info = std::make_shared<mavsdk::Info>(system);
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", "test",
                  "-I#{include}/mavsdk",
                  "-L#{lib}",
                  "-lmavsdk",
                  "-lmavsdk_info"
    system "./test"

    assert_equal "Usage: backend_bin [-h | --help]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
