class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz"
  sha256 "8586084f71f9bde545ee7fa6d00288b264a2b7ac3607b974e54d13e7162c1c72"
  license "MPL-2.0"
  revision 1
  head "https://gitlab.com/libeigen/eigen.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17e1238a80ca448a9e2a1090fd3c0bf54634470757e5dacc08efb730b4fb9fca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17e1238a80ca448a9e2a1090fd3c0bf54634470757e5dacc08efb730b4fb9fca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17e1238a80ca448a9e2a1090fd3c0bf54634470757e5dacc08efb730b4fb9fca"
    sha256 cellar: :any_skip_relocation, sonoma:         "d19fbee3104b5302413c25c2a619dac3fc38e41e4c3f972cf2496d032fde2d96"
    sha256 cellar: :any_skip_relocation, ventura:        "d19fbee3104b5302413c25c2a619dac3fc38e41e4c3f972cf2496d032fde2d96"
    sha256 cellar: :any_skip_relocation, monterey:       "17e1238a80ca448a9e2a1090fd3c0bf54634470757e5dacc08efb730b4fb9fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e1238a80ca448a9e2a1090fd3c0bf54634470757e5dacc08efb730b4fb9fca"
  end

  depends_on "cmake" => :build

  conflicts_with "freeling", because: "freeling ships its own copy of eigen"

  def install
    mkdir "eigen-build" do
      args = std_cmake_args
      args << "-Dpkg_config_libdir=#{lib}" << ".."
      system "cmake", *args
      system "make", "install"
    end
    (share/"cmake/Modules").install "cmake/FindEigen3.cmake"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
