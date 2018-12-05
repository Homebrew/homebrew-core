class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.0.tar.gz"
  sha256 "da4597edf8ebef99961394daca44fa30148c778adff59ee5aec073ea94dcc175"
  revision 2
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    sha256 "7434540f6e690a09b2cb33d1865fe8e1ce7e10368f568c4322866f4d14d7b2b8" => :mojave
    sha256 "b85f87b14e2b59b7c185cc8a002f053b3f99be0d5eda013d037f69f507976379" => :high_sierra
    sha256 "f69fabe254f94764c1d519eb059766936920dcb187999ee9f5210f234b0da93e" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "numpy"
  depends_on "python"
  depends_on "sdl"

  def install
    system "cmake", ".", *std_cmake_args
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
