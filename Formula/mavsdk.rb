class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++11"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
    :tag      => "v0.24.0",
    :revision => "38ec5f6ee52190f2e1f6e14e8d371caec5341009"

  bottle do
    cellar :any
    sha256 "2dd542f036c298a7b96fb05a2d99ad2434e7d4ef38d44b2cfc3895575877a1e4" => :catalina
    sha256 "efe55369ba19e122fb6e37807441eff614511391c4a5fcfd5835c7b9be899448" => :mojave
    sha256 "f15e2683f4851c4fca3fbd10b2c664711401bff00f20c4f151c0213bda145d0d" => :high_sierra
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
