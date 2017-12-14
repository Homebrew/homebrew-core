class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.0.tar.gz"
  sha256 "da4597edf8ebef99961394daca44fa30148c778adff59ee5aec073ea94dcc175"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git"

  bottle do
    cellar :any
    sha256 "209f649196b2f933ef85969199c772861cdc014789a5b38254d64f5f8901d7e8" => :high_sierra
    sha256 "945cf13cda0c218beb42c67647caa94b8e538b8e5a64f62f3c70ff4dcb91f316" => :sierra
    sha256 "fae373f7210a248e3819175902e7e5038bcfbc436f0a49e9bc715c83dbe3818c" => :el_capitan
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
