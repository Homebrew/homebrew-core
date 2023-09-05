class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.8.1.tar.gz"
  sha256 "28960616cd89c18925ced7bbdeec01ab0b2ebd2d8ce5b7c88930e97381b4c3b5"
  license "GPL-2.0-only"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "699b6985a1bb99a9ea1522ca7b5901397f13917293252a17ac8c6bcaf35bf370"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38c820c3fe5fbd93bd584f66eb0f3af35ea46b420b266096c24f0f5540d1b45f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87933443e4fa0c6c1805f71d93ccbae3c02680b6d7f2b8c7253c55ea3b682fbe"
    sha256 cellar: :any_skip_relocation, ventura:        "6857b79af2604afba4dc4ca1ef4a42a7502daa10353afbd2f2722d5f69831d4f"
    sha256 cellar: :any_skip_relocation, monterey:       "2ce0522e1ad5db281ebe18e5556b36a82602e344965b476c633b00b1465036ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "258d393b4a5721a8951428eaf9009490c4dea20b5ad51cceba79014411824e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88e469190049e5d7fd9deff16e715f9571535c1a45451be8d44016a0581b33af"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "sdl2"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  # Don't require importlib-resources for recent pythons
  # https://github.com/mgbellemare/Arcade-Learning-Environment/pull/491
  patch do
    url "https://github.com/mgbellemare/Arcade-Learning-Environment/commit/61da474b8e3b3993969c9e4de3933559598613e1.patch?full_index=1"
    sha256 "72baf458430b81a6b8e56f1fc8edde732ba210c3540a6775000d6393dbcb73dd"
  end

  # Allow building from tarball
  # https://github.com/mgbellemare/Arcade-Learning-Environment/pull/492
  patch do
    url "https://github.com/mgbellemare/Arcade-Learning-Environment/commit/7e3d9ffbca6d97b49f48e46c030b4236eb09019b.patch?full_index=1"
    sha256 "64cf83625fe19bc32097b34853db6752fcf835a3d42909a9ac88315dfca2b85f"
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

    # error: no member named 'signbit' in the global namespace
    inreplace "setup.py", "cmake_args = [", "\\0\"-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}\"," if OS.mac?
    system python3, "-m", "pip", "install", *std_pip_args, "."

    # Replace vendored `libSDL2` with a symlink to our own.
    libsdl2 = Formula["sdl2"].opt_lib/shared_library("libSDL2")
    vendored_libsdl2_dir = prefix/Language::Python.site_packages(python3)/"ale_py"
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
