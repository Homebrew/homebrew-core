class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/Farama-Foundation/Arcade-Learning-Environment"
  url "https://files.pythonhosted.org/packages/3e/e8/e69da8a5fb5feafa9fffb32ed8c2b306b7571b77faf779f61e4eb53304ec/ale_py-0.12.1.tar.gz"
  sha256 "c503d574c5983e1063b451201ccb779d935919c0f6bf116fb0f4f8aa4c86d249"
  license "GPL-2.0-only"
  head "https://github.com/Farama-Foundation/Arcade-Learning-Environment.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "c259e8b4017e598eae705b27b51775028f2503d46337fd07611559d9edd0fae8"
    sha256 cellar: :any, arm64_tahoe:       "8ec5becbe24e85c88b8c53dcd22ea41676a963795421d331db5a5e628f26d9c6"
    sha256 cellar: :any, arm64_sequoia:     "2b9cd238cdae5d0005454fbba547ecfc098c650a7702bcb31443d8e4da3e2c9e"
    sha256 cellar: :any, arm64_linux:       "61b52908b8f89c9d04c9b4d2eb03f9b9b78b8d6a46e6e7131a2155b85ce9aff3"
    sha256 cellar: :any, x86_64_linux:      "b36db8db921a8d64b70ca3756b68e304eb2d7b3a4bbfcfdf6b29450c6ae946fd"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "numpy"
  depends_on "python@3.15"
  depends_on "sdl2-compat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages exclude_packages: "numpy"

  # See https://github.com/Farama-Foundation/Arcade-Learning-Environment/blob/master/scripts/download_unpack_roms.sh
  resource "roms" do
    url "https://gist.githubusercontent.com/jjshoots/61b22aefce4456920ba99f2c36906eda/raw/00046ac3403768bfe45857610a3d333b8e35e026/Roms.tar.gz.b64"
    version "00046ac3403768bfe45857610a3d333b8e35e026"
    sha256 "02ca777c16476a72fa36680a2ba78f24c3ac31b2155033549a5f37a0653117de"

    livecheck do
      url "https://raw.githubusercontent.com/Farama-Foundation/Arcade-Learning-Environment/refs/tags/v#{LATEST_VERSION}/scripts/download_unpack_roms.sh"
      regex(%r{/jjshoots/61b22aefce4456920ba99f2c36906eda/raw/(\h+)/Roms\.t}i)
    end
  end

  def install
    # NOTE: Do not enable vector feature as it uses OpenCV (Apache-2.0) which is incompatible with GPL-2.0-only
    # https://www.gnu.org/licenses/license-list.html#apache2
    # https://www.apache.org/licenses/GPL-compatibility.html
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_VECTOR_LIB=OFF
      -DBUILD_VECTOR_XLA_LIB=OFF
      -DSDL_DYNLOAD=OFF
      -DSDL_SUPPORT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_PYTHON_LIB=OFF", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/resources/tetris.bin"

    # Install ROMs
    resource("roms").stage do
      pwd = Pathname.pwd
      encoded = (pwd/"Roms.tar.gz.b64").read
      (pwd/"Roms.tar.gz").write encoded.unpack1("m")

      system "tar", "-xzf", "Roms.tar.gz"
      (buildpath/"src/python/roms").install pwd.glob("ROM/*/*.bin")
    end

    # We build without XLA and jax has no sdists
    inreplace "pyproject.toml", '"jax >= 0.4.31', "#"

    cmake_args << "-DCMAKE_INSTALL_RPATH=#{rpath(source: prefix/Language::Python.site_packages(python3)/"ale_py")}"
    ENV["CMAKE_ARGS"] = cmake_args.join(" ")
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
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
