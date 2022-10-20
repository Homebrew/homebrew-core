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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adf35799b996642207c8521340a7a0147b3d95f73a201a9b2ee750132ec51864"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7edb9ab548f123e0870883ab5febb193ae47d2d4d1769431e509f988289874d9"
    sha256 cellar: :any_skip_relocation, monterey:       "168806383f23e87f0cf73e70b247162c05fa0dfa4e0e9b6f5d818dcb48325315"
    sha256 cellar: :any_skip_relocation, big_sur:        "de3b95ae2b19b2e9bacd51380efc693a6f10c9513b6c93e00be2ebeef43f9153"
    sha256 cellar: :any_skip_relocation, catalina:       "e09abbcf812cb94058540295d656f9c79cc0078108ead83d158aac6fee2a48fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b386e45174d0450d08c80c5b703c34291d486ead9ee61d11fcc1fdd7f1d1b05"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python@3.10"
  depends_on "sdl2"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/38/b6/bc58f9261c70abb5fd670f9ad5d84445a402b4b473f308c5bf699cd379e0/importlib_resources-5.9.0.tar.gz"
    sha256 "5481e97fb45af8dcf2f798952625591c58fe599d0735d86b10f54de086a61681"
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
