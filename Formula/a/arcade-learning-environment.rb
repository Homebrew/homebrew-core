class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/Farama-Foundation/Arcade-Learning-Environment"
  url "https://github.com/Farama-Foundation/Arcade-Learning-Environment/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "7625ffbb9eb6c0efc6716f34b93bc8339f2396ea5e31191a251cb31bdd363f80"
  license "GPL-2.0-only"
  head "https://github.com/Farama-Foundation/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e0f83738408c077a71d7114a36506355351993db387ce0838e7c9234f7ac9d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65f363115487158523e1f5948012ca96e20261a3477e2b89c52e07c191e23090"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e92cd5c757cd8e5e8b75c18024f5e30fcb1658d997e6caa6845a31360700552"
    sha256 cellar: :any_skip_relocation, sonoma:         "153d0362a36c03f246e6a36b1fb187ed60e61184622345c7621236f78c74d207"
    sha256 cellar: :any_skip_relocation, ventura:        "a737e03e4405e7891b84c1a0b411bed53e0f3910e7e4adb522aaa0f69f4cf06d"
    sha256 cellar: :any_skip_relocation, monterey:       "33501d45df657c5275e0cdb8d61d433cdbf59b668fb6311ad89e097fd8071196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87f844a97941f0bd336d1101df9444784b5ee030b3fca920398e9da694e83224"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "python-setuptools" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "sdl2"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  # See https://github.com/Farama-Foundation/Arcade-Learning-Environment/blob/master/scripts/download_unpack_roms.sh
  resource "roms" do
    url "https://gist.githubusercontent.com/jjshoots/61b22aefce4456920ba99f2c36906eda/raw/00046ac3403768bfe45857610a3d333b8e35e026/Roms.tar.gz.b64"
    sha256 "02ca777c16476a72fa36680a2ba78f24c3ac31b2155033549a5f37a0653117de"
  end

  # Allow building with system pybind11
  # https://github.com/Farama-Foundation/Arcade-Learning-Environment/pull/528
  patch do
    url "https://github.com/Farama-Foundation/Arcade-Learning-Environment/commit/52b326151972d7df663c6afe44d0b699a531739d.patch?full_index=1"
    sha256 "4322db4e4578e08ae9882cee260b7bc4f3477869bcd9295f3f4f3e6c56b29026"
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
    (testpath/"roms.py").write <<~EOS
      from ale_py.roms import get_all_rom_ids
      print(get_all_rom_ids())
    EOS
    assert_match "adventure", shell_output("#{python3} roms.py")

    cp pkgshare/"tetris.bin", testpath
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
