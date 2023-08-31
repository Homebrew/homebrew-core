class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment.git",
      tag:      "v0.8.1",
      revision: "ba84c1480008aa606ebc1efd7a04a7a7729796d4"
  license "GPL-2.0-only"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "287d60790b07e38192dfebfb30e7610d8b78713cf034b83758d665377d215e25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaff14df45237f951184d547b292c4ac81c44b58365847d7b5ea4ffe2d6fbca7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bdda57bca0c681578ea6ab983795e089c4f81cb09c5e80cad264f07923dd3c4"
    sha256 cellar: :any_skip_relocation, ventura:        "db6349ef4ab6ae4cd2a0b47a68e8c0e41644677a1f3db6995a9693a337695ce7"
    sha256 cellar: :any_skip_relocation, monterey:       "ba9280f972eb5ab2a305b29c5c0ba8f409e1236f2b570097ecdf5e44b7cf4ad4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b136f842d9edc8ace1844242642d4b797551b0d0bd2b3fde07bf5269153247ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64f5f513b6373d1d7045d52e607c18bbb9eff0a8afe722322642f17b301877ad"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python-importlib-resources"
  depends_on "python@3.11"
  depends_on "sdl2"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSDL_SUPPORT=ON",
                    "-DSDL_DYNLOAD=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/resources/tetris.bin"

    # error: no member named 'signbit' in the global namespace
    inreplace "setup.py", "cmake_args = [", "\\0\"-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}\"," if OS.mac?

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/ale-import-roms 2>&1", 2)
    assert_match "one of the arguments --import-from-pkg romdir is required", output
    output = shell_output("#{bin}/ale-import-roms .").lines.last.chomp
    assert_equal "Imported 0 / 0 ROMs", output

    cp pkgshare/"tetris.bin", testpath
    output = shell_output("#{bin}/ale-import-roms --dry-run .").lines.first.chomp
    assert_match(/\[SUPPORTED\].*tetris\.bin/, output)

    (testpath/"test.py").write <<~EOS
      from ale_py import ALEInterface, SDL_SUPPORT
      assert SDL_SUPPORT

      ale = ALEInterface()
      ale.setInt("random_seed", 123)
      ale.loadROM("tetris.bin")
      assert len(ale.getLegalActionSet()) == 18
    EOS

    output = shell_output("#{python3} test.py 2>&1")
    assert_match <<~EOS, output
      Game console created:
        ROM file:  tetris.bin
        Cart Name: Tetris 2600 (Colin Hughes)
        Cart MD5:  b0e1ee07fbc73493eac5651a52f90f00
    EOS
    assert_match <<~EOS, output
      Running ROM file...
      Random seed is 123
    EOS
  end
end
