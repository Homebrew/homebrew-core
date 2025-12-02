class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/Farama-Foundation/Arcade-Learning-Environment"
  url "https://github.com/Farama-Foundation/Arcade-Learning-Environment/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "d6ac9406690bb3533b37a99253bdfc59bc27779c5e1b6855c763d0b367bcbf96"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/Farama-Foundation/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8f064101937b69531d91019cbe7707ede64b32c80ca1a5c25c654d1659331484"
    sha256 cellar: :any,                 arm64_sequoia: "da30b51a9970f4021b5b868cdae341c1b935e686eaefeb8b736d745db77afa2f"
    sha256 cellar: :any,                 arm64_sonoma:  "6812d9341ff79682a410b8e9049595a686f89bdbb60772b6b3b3707c945ec852"
    sha256 cellar: :any,                 sonoma:        "77504f7bbe80fcd02974ee91650ce2abf27289a4abf1f4de18c111ea72c7d550"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adbb8756e9d7682016e87d35a9a7fd9f5bb4eb9125f7b5a68e96166b3f04ec86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a62c769d2dd61d395d321f74dfbafc5f1b8c38c2df4434ef21d45f0a53e7528"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pybind11" => :build
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python@3.14"
  depends_on "sdl2"

  uses_from_macos "zlib"

  pypi_packages exclude_packages: "numpy",
                extra_packages:   "gymnasium"

  # See https://github.com/Farama-Foundation/Arcade-Learning-Environment/blob/master/scripts/download_unpack_roms.sh
  resource "roms" do
    url "https://gist.githubusercontent.com/jjshoots/61b22aefce4456920ba99f2c36906eda/raw/00046ac3403768bfe45857610a3d333b8e35e026/Roms.tar.gz.b64"
    sha256 "02ca777c16476a72fa36680a2ba78f24c3ac31b2155033549a5f37a0653117de"
  end

  resource "cloudpickle" do
    url "https://files.pythonhosted.org/packages/52/39/069100b84d7418bc358d81669d5748efb14b9cceacd2f9c75f550424132f/cloudpickle-3.1.1.tar.gz"
    sha256 "b216fa8ae4019d5482a8ac3c95d8f6346115d8835911fd4aefd1a445e4242c64"
  end

  resource "farama-notifications" do
    url "https://files.pythonhosted.org/packages/2e/2c/8384832b7a6b1fd6ba95bbdcae26e7137bb3eedc955c42fd5cdcc086cfbf/Farama-Notifications-0.0.4.tar.gz"
    sha256 "13fceff2d14314cf80703c8266462ebf3733c7d165336eee998fc58e545efd18"
  end

  resource "gymnasium" do
    url "https://files.pythonhosted.org/packages/b3/de/b923d09654df8f8ee29a3cc7ec7829ac057efd0d969cc3da0c8a7b219d59/gymnasium-1.2.1.tar.gz"
    sha256 "4e6480273528523a90b3db99befb6111b13f15fa0866de88c4b675770495b66c"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def python3
    "python3.14"
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

    inreplace "setup.py" do |s|
      # error: no member named 'signbit' in the global namespace
      s.gsub! "cmake_args = [", "\\0\"-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}\"," if OS.mac?
      # Remove XLA support for now
      s.gsub! "-DBUILD_VECTOR_XLA_LIB=ON", ""
    end
    # We build without XLA and jax has no sdists
    inreplace "pyproject.toml", '"jax >= 0.4.31', "#"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.select { |r| r.url.start_with?("https://files.pythonhosted.org/") }
    venv.pip_install_and_link Pathname.pwd
    (prefix/Language::Python.site_packages(python3)/"homebrew-ale.pth").write venv.site_packages

    # Replace vendored `libSDL2` with a symlink to our own.
    libsdl2 = Formula["sdl2"].opt_lib/shared_library("libSDL2")
    vendored_libsdl2_dir = venv.site_packages/"ale_py"
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
