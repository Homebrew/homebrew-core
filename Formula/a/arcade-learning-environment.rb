class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/Farama-Foundation/Arcade-Learning-Environment"
  url "https://github.com/Farama-Foundation/Arcade-Learning-Environment/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "d6ac9406690bb3533b37a99253bdfc59bc27779c5e1b6855c763d0b367bcbf96"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/Farama-Foundation/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "b009980ff04c5a5b689483a5fcad22e0a559d29c399e062fac1a19e53f1a3556"
    sha256 cellar: :any,                 arm64_sequoia: "67db538108663fb4911c74cb33d5ce338fe0840a01bb2c61ce333058e61d80e6"
    sha256 cellar: :any,                 arm64_sonoma:  "f7a857a6b08ab38794b62b76c3d583bf36b4e359dab1b240e995fd68d8faf6f7"
    sha256 cellar: :any,                 sonoma:        "a78b791f22db217b1fd7c21dfefe8713d227bd072919c5c27595cfe7bc348bf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "255d28dc23befe545d9cf3c78e6117d6b20b6b5cdc36b718ca49f8fdfdb46590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "564c60983aee242bd8f04bfca81e40ac2b1214d2f15897ab2e59106dedf98e4f"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python@3.14"
  depends_on "sdl2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:     "ale-py[vector]",
                exclude_packages: %w[numpy opencv-python],
                extra_packages:   "pybind11==3.0.1" # TODO: remove in next release

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

  resource "cloudpickle" do
    url "https://files.pythonhosted.org/packages/27/fb/576f067976d320f5f0114a8d9fa1215425441bb35627b1993e5afd8111e5/cloudpickle-3.1.2.tar.gz"
    sha256 "7fda9eb655c9c230dab534f1983763de5835249750e85fbcef43aaa30a9a2414"
  end

  resource "farama-notifications" do
    url "https://files.pythonhosted.org/packages/2e/2c/8384832b7a6b1fd6ba95bbdcae26e7137bb3eedc955c42fd5cdcc086cfbf/Farama-Notifications-0.0.4.tar.gz"
    sha256 "13fceff2d14314cf80703c8266462ebf3733c7d165336eee998fc58e545efd18"
  end

  resource "gymnasium" do
    url "https://files.pythonhosted.org/packages/76/59/653a9417d98ed3e29ef9734ba52c3495f6c6823b8d5c0c75369f25111708/gymnasium-1.2.3.tar.gz"
    sha256 "2b2cb5b5fbbbdf3afb9f38ca952cc48aa6aa3e26561400d940747fda3ad42509"
  end

  resource "pybind11" do
    url "https://files.pythonhosted.org/packages/2f/7b/a6d8dcb83c457e24a9df1e4d8fd5fb8034d4bbc62f3c324681e8a9ba57c2/pybind11-3.0.1.tar.gz"
    sha256 "9c0f40056a016da59bab516efb523089139fcc6f2ba7e4930854c61efb932051"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def python3
    "python3.14"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.select { |r| r.url.start_with?("https://files.pythonhosted.org/") }
    ENV.prepend_path "CMAKE_PREFIX_PATH", venv.site_packages/"pybind11"

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
