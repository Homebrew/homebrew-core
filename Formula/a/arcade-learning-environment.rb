class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment/archive/v0.8.1.tar.gz"
  sha256 "28960616cd89c18925ced7bbdeec01ab0b2ebd2d8ce5b7c88930e97381b4c3b5"
  license "GPL-2.0-only"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c810cfd1c114453a2680a98616eb6655ed4e77d826c297808f116535263cacc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b83fafd9f9ba1938c7afa2ba873825379cd45b3cd169d3baf35688000cfba8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f1ad5d707bbfe02484dcf7d26f1a198fb9d6bec141eabad5692e14b12f342b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "854b443122257bbb7b8667b2e9f828b252e3aace232673bf98ad69ecca5e2c69"
    sha256 cellar: :any_skip_relocation, ventura:        "fd24aee3582a77d3db5a74d7ec2faf2f64a8c44dbc16500c1585205a8175e963"
    sha256 cellar: :any_skip_relocation, monterey:       "ca022cfbef7d0b2f6d68b03bf14300d600df758b72743473a4960daa6cbb6368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "055912b9b89d3c61cad420eaa394554ab75c1465489f0a70519466ec6d2d4778"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python@3.12"
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
    "python3.12"
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
