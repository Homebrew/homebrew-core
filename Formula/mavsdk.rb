class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++11"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
    :tag      => "v0.28.0",
    :revision => "a9b2416293aad8dee1b6ad0f9d39f7072b1e66b4"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "21ec782d1a4aa1783920a53c924c698fec26e9d42c32042fd66ed11953efb1cd" => :catalina
    sha256 "41383056b82b35e21af26de42729fb6a9ea130b6171d225dfb49d834e955751b" => :mojave
    sha256 "c3dc48e7f6c46b186c01be66fa5b59ee90050ae76a2692ee99c475cead5c82a9" => :high_sierra
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
