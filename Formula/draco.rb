class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.2.4.tar.gz"
  sha256 "993c78880f4bbd2bfbc7b1e16809c2f62f8ecf9040f68db75ca65be3ac34be4f"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DENABLE_TESTS=ON"
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    shell_output("#{bin}/draco_encoder --help", 255)
  end
end
