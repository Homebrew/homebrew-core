class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++11"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
    :tag      => "v0.22.0",
    :revision => "164e5fe719608898b009364dbd870846d5163bfc"

  bottle do
    cellar :any
    sha256 "502efdf39843aa6c52174d55597d0c79ba0869ce08294cad731d4aa721327fef" => :catalina
    sha256 "13815dcd09df20a9dd8dab702bb1887b45ffc1a3090ad054db3f4e30d107db6d" => :mojave
    sha256 "7274d048bd1cff800d01e3a4af1b42a7843b9e1798243d304fe57b916adf69cd" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-Bbuild/default",
                    "-DBUILD_BACKEND=ON",
                    "-DCMAKE_BUILD_TYPE=Release",
                    "-DCMAKE_INSTALL_PREFIX=#{prefix}",
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
