class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.1.tar.gz"
  sha256 "8059a4087680da03878c1648a8ceb0413a341032ecaa44bef4ef1f9f829b6dde"
  revision 1
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    sha256 "7c00ddc0d9693ceaba062b77fb94e2a7aea2e6ccdfd16bb877c00c24e1ceaa48" => :catalina
    sha256 "1ccf63b1ee913ffeffcbc28d36e75bfc6c28f5afac6b51ff31e28d0dd06f51fd" => :mojave
    sha256 "bf91e1153dcc19178f77faa72b1761a5dcb284626cf16065196011d7b7d7ef6d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "numpy"
  depends_on "python@3.8"
  depends_on "sdl"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
    ]
    system "cmake", ".", *args
    system "make", "install"
    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    output = shell_output("#{bin}/ale 2>&1", 1).lines.last.chomp
    assert_equal "No ROM File specified.", output
    (testpath/"test.py").write <<~EOS
      from ale_python_interface import ALEInterface;
      ale = ALEInterface();
    EOS
    assert_match "ale.cfg", shell_output("#{Formula["python@3.8"].opt_bin}/python3 test.py 2>&1")
  end
end
