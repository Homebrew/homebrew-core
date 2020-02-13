class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.1.tar.gz"
  sha256 "8059a4087680da03878c1648a8ceb0413a341032ecaa44bef4ef1f9f829b6dde"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    sha256 "0d8227ac63b86e27b3289137f96b99488231fad2390fc80eb2d19d8495562587" => :catalina
    sha256 "c1df5b72ac9f1048c11b51133b3c703cab7ff5f184e5a3ac80df559ea7332f66" => :mojave
    sha256 "4347e69ed56c1798240b6c160d7ddaedf5ecc2fb56b8d235c644ef44103f3dc9" => :high_sierra
    sha256 "327944c55b6c2b917bfdc04c8cdfaffe59ecea5851f326369901949c0657a5ed" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "numpy"
  depends_on "python"
  depends_on "sdl"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
    ]
    system "cmake", ".", *args
    system "make", "install"
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    output = shell_output("#{bin}/ale 2>&1", 1).lines.last.chomp
    assert_equal "No ROM File specified.", output
    (testpath/"test.py").write <<~EOS
      from ale_python_interface import ALEInterface;
      ale = ALEInterface();
    EOS
    assert_match "ale.cfg", shell_output("python3 test.py 2>&1")
  end
end
