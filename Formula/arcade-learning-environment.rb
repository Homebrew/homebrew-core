class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.0.tar.gz"
  sha256 "da4597edf8ebef99961394daca44fa30148c778adff59ee5aec073ea94dcc175"
  revision 4
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    sha256 "c79e9774e032cadea98b221ba56686d6389430952549bb617551cb6955d03900" => :mojave
    sha256 "873ad323d8cc12f7af3fa9c1476bfe61454c9d1d161e9e5db70a90a7a5fab3e2" => :high_sierra
    sha256 "fc3cbad386c70e97b16bd48b19f3d86bc73c1de3d24e396861e645884309a7ab" => :sierra
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
