class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.0.tar.gz"
  sha256 "da4597edf8ebef99961394daca44fa30148c778adff59ee5aec073ea94dcc175"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1beafa718ffc4e150cf3ad410f6172488c6700f5004fe95898f5f7d20d39d154" => :mojave
    sha256 "f89556072efec9025561b663ab9f2f5c613104e014bd28b9bd2e39b98de1aae3" => :high_sierra
    sha256 "58daf6e1208b05e9fe09825a671c6821acc550d6f13ae4419bd47dee0c421181" => :sierra
    sha256 "453a32af23fe2e68897267d4cd0e8ed728b50e4623d98c6b9d55612e2bdcba29" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "numpy"
  depends_on "python@2"
  depends_on "sdl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    output = shell_output("#{bin}/ale 2>&1", 1).lines.last.chomp
    assert_equal "No ROM File specified.", output
    (testpath/"test.py").write <<~EOS
      from ale_python_interface import ALEInterface;
      ale = ALEInterface();
    EOS
    assert_match "ale.cfg", shell_output("python test.py 2>&1")
  end
end
