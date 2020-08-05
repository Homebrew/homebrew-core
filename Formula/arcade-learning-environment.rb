class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.1.tar.gz"
  sha256 "8059a4087680da03878c1648a8ceb0413a341032ecaa44bef4ef1f9f829b6dde"
  revision 1
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    sha256 "dc3acdec1e0fa77c0989f669df73ac9260611e3542db9cd371d27260276037a9" => :catalina
    sha256 "9fbb8f0997a3ca959a1e2a6e972c4100069b88bbf0450d3ed099a6b344238ca0" => :mojave
    sha256 "bb28107f88fe1615bd737c5fa76d195e27625e5d9139fd7e9168045952926d22" => :high_sierra
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
