class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment.git",
      tag:      "v0.7.5",
      revision: "db3728264f382402120913d76c4fa0dc320ef59f"
  license "GPL-2.0-only"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "69b3c918b471d86a15ddc33ca7d8788b7df97cdb37c24b0f9bf278acea044a92"
    sha256 cellar: :any,                 arm64_big_sur:  "b91365dd433a5aaa6c63e1930fa485a0c7d8f30aee4709f77d47a1c227aad39c"
    sha256 cellar: :any,                 monterey:       "928deddbfd6b71a6683d9baabb34e95e42b2426e306d050cf785e5aa0ea45c07"
    sha256 cellar: :any,                 big_sur:        "385f3c78c9926ea3cf5fb5ea44d0ef363d3c097058e039e822a127d3f7f031f1"
    sha256 cellar: :any,                 catalina:       "6b4982ba66a1dae92d8894c64d10413eefe553bcb3e368770d49a4ea66b6af3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11739052d50db05aac650a0d23c46aeb04535b9ff97b982c3687bb5baac0fbbc"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python@3.10"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  # Issue building with older setuptools currently included with Python 3.10.4.
  # TODO: remove after next python update
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4a/25/ec29a23ef38b9456f9965c57a9e1221e6c246d87abbf2a31158799bca201/setuptools-62.3.2.tar.gz"
    sha256 "a43bdedf853c670e5fed28e5623403bad2f73cf02f9a2774e91def6bda8265a7"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/07/3c/4e27ef7d4cea5203ed4b52b7fe96ddd08559d9f147a2a4307e7d6d98c035/importlib_resources-5.7.1.tar.gz"
    sha256 "b6062987dfc51f0fcb809187cffbd60f35df7acb4589091f154214af6d0d49d3"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_NAME_DIR=#{opt_lib}",
                    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON",
                    "-DSDL_SUPPORT=ON",
                    "-DSDL_DYNLOAD=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/resources/tetris.bin"

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    # error: no member named 'signbit' in the global namespace
    inreplace "setup.py", "cmake_args = [", "\\0\"-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}\"," if OS.mac?

    # `venv.pip_install_and_link buildpath` fails to install scripts, so manually run setup.py instead
    bin_before = Dir[libexec/"bin/*"].to_set
    system libexec/"bin/python3", *Language::Python.setup_install_args(libexec)
    bin.install_symlink (Dir[libexec/"bin/*"].to_set - bin_before).to_a

    site_packages = Language::Python.site_packages("python3")
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-ale-py.pth").write pth_contents
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

    output = shell_output("#{Formula["python@3.10"].opt_bin}/python3 test.py 2>&1")
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
