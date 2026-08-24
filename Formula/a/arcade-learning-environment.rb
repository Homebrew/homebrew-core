class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/Farama-Foundation/Arcade-Learning-Environment"
  url "https://files.pythonhosted.org/packages/3e/e8/e69da8a5fb5feafa9fffb32ed8c2b306b7571b77faf779f61e4eb53304ec/ale_py-0.12.1.tar.gz"
  sha256 "c503d574c5983e1063b451201ccb779d935919c0f6bf116fb0f4f8aa4c86d249"
  license "GPL-2.0-only"
  head "https://github.com/Farama-Foundation/Arcade-Learning-Environment.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1238599d305a9c092143312c8e71e2ca7b7b4a468638d1b33e6b733484d2e822"
    sha256 cellar: :any, arm64_sequoia: "c572fcd1e2d4d2ad979e426d0d0c4bb81cc57fe958a7c61a7236aa68a9194a0f"
    sha256 cellar: :any, arm64_sonoma:  "3b44b4e9016f44fe64042ea3a12c6198e00a2c1aa93fe29863be415ecd0dcb50"
    sha256 cellar: :any, sonoma:        "d60ce709607371bc0f4639123941d8ed454d825a5b6ed3c7dff67dc970e1d273"
    sha256 cellar: :any, arm64_linux:   "4ae126bae532827def08955d695d51c3c109bdf03ad87655a9aceeb9044af069"
    sha256 cellar: :any, x86_64_linux:  "71a05850ffc86e03af98c2a62343b77d4e2d92d2402ab37ef84790b7bf9be253"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "numpy"
  depends_on "python@3.14"
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

  def python3
    "python3.14"
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
