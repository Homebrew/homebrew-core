class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment.git",
      tag:      "v0.8.1",
      revision: "ba84c1480008aa606ebc1efd7a04a7a7729796d4"
  license "GPL-2.0-only"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f33932e7707d642c4fdc38f5474d8ee82c6cd7c31491081e947d5df4445a8a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c26a068c64184f700b8b638e37c978b9e4b611e74fb5834016982706c7dd4009"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35debc9b99e3b5142b5f626a8fa370c8025ba2f09f8d64c7948e4387d84beb2a"
    sha256 cellar: :any_skip_relocation, ventura:        "afc216243c7e72bbc41c9c2b1c9e5b0ec3c7efe5bd55b091202f441cbce03f90"
    sha256 cellar: :any_skip_relocation, monterey:       "efb722d0b171efa9869925d762361d301a98181d8dd053972cbff2b1dad80ef4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb7e5a9f35472e9b25499a5163cea73b27026908bee527aee9e521229676db00"
    sha256 cellar: :any_skip_relocation, catalina:       "6c9f67f4b5653089a35e6d50df593bd93ed60078cbce10ca815f2aca176a6f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63248a068444838a906590b26dabe111465a225de384c50c7f89faac0be16c92"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "sdl2"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/4e/a2/3cab1de83f95dd15297c15bdc04d50902391d707247cada1f021bbfe2149/importlib_resources-5.12.0.tar.gz"
    sha256 "4be82589bf5c1d7999aedf2a45159d10cb3ca4f19b2271f8792bc8e6da7b22f6"
  end

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

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    # error: no member named 'signbit' in the global namespace
    inreplace "setup.py", "cmake_args = [", "\\0\"-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}\"," if OS.mac?

    # `venv.pip_install_and_link buildpath` fails to install scripts, so manually run setup.py instead
    bin_before = (libexec/"bin").children.to_set
    venv_python = libexec/"bin/python"
    system venv_python, *Language::Python.setup_install_args(libexec, venv_python)
    bin.install_symlink ((libexec/"bin").children.to_set - bin_before).to_a

    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-ale-py.pth").write pth_contents

    # Replace vendored `libSDL2` with a symlink to our own.
    libsdl2 = Formula["sdl2"].opt_lib/shared_library("libSDL2")
    vendored_libsdl2_dir = libexec/site_packages/"ale_py"
    (vendored_libsdl2_dir/shared_library("libSDL2")).unlink

    # Use `ln_s` to avoid referencing a Cellar path.
    ln_s libsdl2.relative_path_from(vendored_libsdl2_dir), vendored_libsdl2_dir
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
