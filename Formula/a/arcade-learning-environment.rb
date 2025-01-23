class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/Farama-Foundation/Arcade-Learning-Environment"
  url "https://github.com/Farama-Foundation/Arcade-Learning-Environment/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "7e0473de29b63f59054f8a165a968cf5a168bd9c07444d377a1f70401d268894"
  license "GPL-2.0-only"
  head "https://github.com/Farama-Foundation/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d2dc919768a30ae5a1eb6c9f14fc17dc0c147d31f605da455c209c3c19a41d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6158a024610dcc4152be365fd0a2207d893c9cfbdb9f517738a9044aade0669"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8015a500d5336680a7abe821b1df3a5bdb5b33c19e233879523ab3ca2b85d85"
    sha256 cellar: :any_skip_relocation, sonoma:        "83feffd8c4a60349927a1db51771d4b15e01e703e1a27b22c161a2269152789c"
    sha256 cellar: :any_skip_relocation, ventura:       "bbbaa60dd14855a7bc812370a90fe5c7f50bf26eb0c71cfec076869b68389755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b8980ab1f4041955854a8801dfa13117fec012ce3a338ed52044ea84709e016"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "python-setuptools" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "sdl2"

  uses_from_macos "zlib"

  # See https://github.com/Farama-Foundation/Arcade-Learning-Environment/blob/master/scripts/download_unpack_roms.sh
  resource "roms" do
    url "https://gist.githubusercontent.com/jjshoots/61b22aefce4456920ba99f2c36906eda/raw/00046ac3403768bfe45857610a3d333b8e35e026/Roms.tar.gz.b64"
    sha256 "02ca777c16476a72fa36680a2ba78f24c3ac31b2155033549a5f37a0653117de"
  end

  def python3
    "python3.13"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSDL_SUPPORT=ON",
                    "-DSDL_DYNLOAD=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/resources/tetris.bin"

    # Install ROMs
    resource("roms").stage do
      require "base64"

      pwd = Pathname.pwd
      encoded = (pwd/"Roms.tar.gz.b64").read
      (pwd/"Roms.tar.gz").write Base64.decode64(encoded)

      system "tar", "-xzf", "Roms.tar.gz"
      (buildpath/"src/python/roms").install pwd.glob("ROM/*/*.bin")
    end

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
    (testpath/"roms.py").write <<~PYTHON
      from ale_py.roms import get_all_rom_ids
      print(get_all_rom_ids())
    PYTHON
    assert_match "adventure", shell_output("#{python3} roms.py")

    cp pkgshare/"tetris.bin", testpath
    (testpath/"test.py").write <<~PYTHON
      from ale_py import ALEInterface, SDL_SUPPORT
      assert SDL_SUPPORT

      ale = ALEInterface()
      ale.setInt("random_seed", 123)
      ale.loadROM("tetris.bin")
      assert len(ale.getLegalActionSet()) == 18
    PYTHON

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
