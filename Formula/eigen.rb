class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://bitbucket.org/eigen/eigen/get/3.2.10.tar.bz2"
  sha256 "760e6656426fde71cc48586c971390816f456d30f0b5d7d4ad5274d8d2cb0a6d"
  head "https://bitbucket.org/eigen/eigen", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "7feb47c34b7b5a91e1d7175f3aef8f5226dc2ae1ec5df90f85d12e11cba7f425" => :sierra
    sha256 "5bee0cf6f6c64d467ef5137aa05581735d45128a8c532c0fe9f6600db75dbb53" => :el_capitan
    sha256 "7f18b841e313362745c87b4e71f3730619559203e0f2e874701f2e2e83533803" => :yosemite
    sha256 "4a2f963a6ea117369a31e68f3c85081d58f187e886a38164c439508272076761" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build

  def install
    ENV.universal_binary if build.universal?

    mkdir "eigen-build" do
      args = std_cmake_args
      args << "-Dpkg_config_libdir=#{lib}" << ".."
      system "cmake", *args
      system "make", "install"
    end
    (share/"cmake/Modules").install "cmake/FindEigen3.cmake"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <Eigen/Dense>
      using Eigen::MatrixXd;
      int main()
      {
        MatrixXd m(2,2);
        m(0,0) = 3;
        m(1,0) = 2.5;
        m(0,1) = -1;
        m(1,1) = m(1,0) + m(0,1);
        std::cout << m << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/eigen3", "-o", "test"
    assert_equal %w[3 -1 2.5 1.5], shell_output("./test").split
  end
end
