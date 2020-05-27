class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++11"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
    :tag      => "v0.26.0",
    :revision => "62fa8925d1d7e98b0dd4f167b9a319e84d16c152"

  bottle do
    cellar :any
    sha256 "3c1d4d0b516c4d7ac452f547e544c6ff47c628982a151c924d1b463a6495081f" => :catalina
    sha256 "f5e229da5563049e46a9897e830e13761ab9fbb65b8f836054def66efbd5b3f6" => :mojave
    sha256 "c56be88b8ae42004960dd87e9b8150d6ae44c79270440b83eb219eaae8e28529" => :high_sierra
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
