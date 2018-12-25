class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.0.tar.gz"
  sha256 "da4597edf8ebef99961394daca44fa30148c778adff59ee5aec073ea94dcc175"
  revision 3
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    sha256 "650f4b525c0ec6d8c4716b4ef4acf3bcf6fb754bc425fe02986a28b42f11ed1d" => :mojave
    sha256 "23210afaa7fdf64dbe85d75682ef7234d9e0d84a94e3f0691015d5e0bccc9d3b" => :high_sierra
    sha256 "ce438bce03014df33bb3354032f62427e9018fc3e5febe26748bdbb5615d3844" => :sierra
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
