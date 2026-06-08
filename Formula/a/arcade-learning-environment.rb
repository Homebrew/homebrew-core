class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/Farama-Foundation/Arcade-Learning-Environment"
  url "https://github.com/Farama-Foundation/Arcade-Learning-Environment/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "021bc469903d7b7ea39e5cc51116baa9068e4d8e3b34bf0516767f49b84fa5c1"
  license "GPL-2.0-only"
  head "https://github.com/Farama-Foundation/Arcade-Learning-Environment.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4abe8e5552022352f45e8b5d59d8b8b12cc69c67bf49664f6f010bb3a3ebbad5"
    sha256 cellar: :any, arm64_sequoia: "e5c7e7d63ea63fd0061cd2d8b89abe78c9864e8bce25c5a51fe4e8918e39f49c"
    sha256 cellar: :any, arm64_sonoma:  "48022de8ccf34458eecfce6bed4fcdb11e3ce12a0b1b248270fa3e0f48d686dd"
    sha256 cellar: :any, sonoma:        "9ee4d956cff029839053a92090716c18b5c368663932b209dacdd2b86118efdb"
    sha256 cellar: :any, arm64_linux:   "aa410e20717f006304b294ac303abd24c4fb156d5b0c08a723768c0a3402a31d"
    sha256 cellar: :any, x86_64_linux:  "203fc30b16516bdfd294538c105aad11213c93739693328c747cff28ff405ed7"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "sdl2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      require "base64"

      pwd = Pathname.pwd
      encoded = (pwd/"Roms.tar.gz.b64").read
      (pwd/"Roms.tar.gz").write Base64.decode64(encoded)

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
