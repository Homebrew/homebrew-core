class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment.git",
      tag:      "v0.8.0",
      revision: "d59d00688b58c5c14dff5fc79db5c22e86987f5d"
  license "GPL-2.0-only"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f44aa61c351794dacdd3156f3e9747d2d0c6af6ef6e24daad37d3088f11b778c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fd32b01bfd47208e8c915d7a7f1d72a7508834a67a34a470319c9667f23ba75"
    sha256 cellar: :any_skip_relocation, monterey:       "4da8b46caf13dd98f1ed7154dee2db9cbe9747dfde30e6e597fbe5455ccb93aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "d533c3f619efa49e2b9f4c45f8b7f7d16186dababb36ce2aad167741156c9b6a"
    sha256 cellar: :any_skip_relocation, catalina:       "e2d34a7ce0ed9c85cc3e77df1aac73df83b1e68df5ad2b3ad3cce8eccce2d7d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31838cbb634a1cc7803fccf6b454bd9437b72a9e92e72f9541fe81615174093a"
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

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/07/3c/4e27ef7d4cea5203ed4b52b7fe96ddd08559d9f147a2a4307e7d6d98c035/importlib_resources-5.7.1.tar.gz"
    sha256 "b6062987dfc51f0fcb809187cffbd60f35df7acb4589091f154214af6d0d49d3"
  end

  def python3
    "python3.10"
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
    system libexec/"bin/python", *Language::Python.setup_install_args(libexec)
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
