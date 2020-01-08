class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://ensmallen.org/files/ensmallen-2.11.1.tar.gz"
  sha256 "c1343f4a61817a396866e497912cc3cd918600c4778869ce8a4f46a5474b980b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d23b32d396820798a0a059a1d9f5272256619360dd71fad53023450b373e322d" => :catalina
    sha256 "44b5b437fa4e990f5a0a9b707cb6052b4ca1656e063df638a5408fbfa26a0295" => :mojave
    sha256 "44b5b437fa4e990f5a0a9b707cb6052b4ca1656e063df638a5408fbfa26a0295" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "armadillo"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ensmallen.hpp>
      using namespace ens;
      int main()
      {
        test::RosenbrockFunction f;
        arma::mat coordinates = f.GetInitialPoint();
        Adam optimizer(0.001, 32, 0.9, 0.999, 1e-8, 3, 1e-5, true);
        optimizer.Optimize(f, coordinates);
        return 0;
      }
    EOS
    cxx_with_flags = ENV.cxx.split + ["test.cpp",
                                      "-std=c++11",
                                      "-I#{include}",
                                      "-I#{Formula["armadillo"].opt_lib}/libarmadillo",
                                      "-o", "test"]
    system *cxx_with_flags
  end
end
