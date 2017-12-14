class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.0.tar.gz"
  sha256 "da4597edf8ebef99961394daca44fa30148c778adff59ee5aec073ea94dcc175"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    sha256 "d031a38caf79f301366df5cc5dfa6bca2408beb27c861ad00ee832f044d4b57b" => :high_sierra
    sha256 "95345e80e773b61d36a31cf8f8e98666c8749dd498ed0923f1453310b2dfd4b0" => :sierra
    sha256 "f12551af8c216c1bc17e87e97b1cd7024aeff2405a8e63b2fb3b73535e34372a" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :python if MacOS.version <= :snow_leopard
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
