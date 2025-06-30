class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/Farama-Foundation/Arcade-Learning-Environment"
  url "https://github.com/Farama-Foundation/Arcade-Learning-Environment/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "2b878ae1b7febb498c7ab5351791c6d9838dc214b4825eec0df1b53b58b6aaa3"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/Farama-Foundation/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "8d87d2e4b11ba564c543865131922e5c1dff39a4e435b6131de0457dd22cae2c"
    sha256 cellar: :any,                 arm64_ventura: "95950e96cce466d33d976383da6074fbe79edc88e1b4510c80eb3477821e7907"
    sha256 cellar: :any,                 sonoma:        "b44653d20e65755dee7012979796e55627f91364cb7c64354498ffdf1829eb0d"
    sha256 cellar: :any,                 ventura:       "29c3bd51a8760f8b9aca78895128398104a088fec43d5af6c12a08e66716eaa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d152b9cf2c6106dfc85851479e7218cee002053d30b36a5c528e14ecba8ffd73"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pybind11" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python@3.13"
  depends_on "sdl2"

  uses_from_macos "zlib"

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
    url "https://files.pythonhosted.org/packages/fd/17/c2a0e15c2cd5a8e788389b280996db927b923410de676ec5c7b2695e9261/gymnasium-1.2.0.tar.gz"
    sha256 "344e87561012558f603880baf264ebc97f8a5c997a957b0c9f910281145534b0"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
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

    inreplace "setup.py" do |s|
      # error: no member named 'signbit' in the global namespace
      s.gsub! "cmake_args = [", "\\0\"-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}\"," if OS.mac?
      # Remove XLA support for now
      s.gsub! "-DBUILD_VECTOR_XLA_LIB=ON", ""
    end
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
