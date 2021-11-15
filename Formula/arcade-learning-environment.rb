class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.6.1.tar.gz"
  sha256 "8059a4087680da03878c1648a8ceb0413a341032ecaa44bef4ef1f9f829b6dde"
  license "GPL-2.0"
  revision 2
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ac79a55da2582b1750e695bbe66943cd3e79111708b0692edad3fdefb870d291"
    sha256 cellar: :any,                 monterey:      "c90f61c52de01f7e1c8387d06030c78e23425246af5d05162481964874285b3a"
    sha256 cellar: :any,                 big_sur:       "0cd35bdc93604828c1c9afc56f47f827ad27f735315a001a04c6864778daf03c"
    sha256 cellar: :any,                 catalina:      "86f7ee81ae0de6f7eebd78bf21dbc79b8230689c275ba812b6ef772b9774118f"
    sha256 cellar: :any,                 mojave:        "eb678eb7cf4205890d5feecfcdf9a06a7afe3f90b5b3159bc5460f2ee2467c0b"
    sha256 cellar: :any,                 high_sierra:   "13856fba32b0dd67c81787b198d71ba02df7fa3a1e2b6e2d552b141c5f901855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64e68f6cc4a0a5cac29d81c8aa0dafb65ab5c635fb7971514e25923b84d1710e"
  end

  depends_on "cmake" => :build
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "sdl"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
    ]
    system "cmake", ".", *args
    system "make", "install"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    output = shell_output("#{bin}/ale 2>&1", 1).lines.last.chomp
    assert_equal "No ROM File specified.", output
    (testpath/"test.py").write <<~EOS
      from ale_python_interface import ALEInterface;
      ale = ALEInterface();
    EOS
    assert_match "ale.cfg", shell_output("#{Formula["python@3.9"].opt_bin}/python3 test.py 2>&1")
  end
end
