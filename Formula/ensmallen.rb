class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.19.1.tar.gz"
  sha256 "f36ad7f08b0688d2a8152e1c73dd437c56ed7a5af5facf65db6ffd977b275b2e"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2dcee0b64d7b446fbce623f8be8e56042bc8599baff5a27571c88da0b432ba7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2931d8a9fecaa829d52f21f741f100e7b1ea16239b8c3b21b54c15f3cfa6ad2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dbb56c37023d39606132a529421d674506ff2fefefae88f0728b0a47d227fb2"
    sha256 cellar: :any_skip_relocation, ventura:        "a8a11bfb7ef9940e933110173a1e93d2d8ef9c85a9d8857f72e49cb01ed6506f"
    sha256 cellar: :any_skip_relocation, monterey:       "5ffdd9861db40c13e54c41ad2a64f9c05e9a3017c6f37fbf4f2ca6d84a9e6c28"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac6fd8911fa61f3c0fd42a6c65fd1388b2dbff3434a358f2b69fe6ce6b62a0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b30b48bbd7cd14d38271d73b3bd013f33ae24e38cb1e96bab6030bd15fd51a8b"
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
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{Formula["armadillo"].opt_lib}",
                    "-larmadillo", "-o", "test"
  end
end
