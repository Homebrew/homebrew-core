class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment.git",
      tag:      "v0.7.4",
      revision: "069f8bd860b9da816cea58c5ade791025a51c105"
  license "GPL-2.0-only"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b8e537aaa1ce408d0fe9cc7d02fd81267d28547f118d64faa82ef10e431b7264"
    sha256 cellar: :any,                 arm64_big_sur:  "ac79a55da2582b1750e695bbe66943cd3e79111708b0692edad3fdefb870d291"
    sha256 cellar: :any,                 monterey:       "c90f61c52de01f7e1c8387d06030c78e23425246af5d05162481964874285b3a"
    sha256 cellar: :any,                 big_sur:        "0cd35bdc93604828c1c9afc56f47f827ad27f735315a001a04c6864778daf03c"
    sha256 cellar: :any,                 catalina:       "86f7ee81ae0de6f7eebd78bf21dbc79b8230689c275ba812b6ef772b9774118f"
    sha256 cellar: :any,                 mojave:         "eb678eb7cf4205890d5feecfcdf9a06a7afe3f90b5b3159bc5460f2ee2467c0b"
    sha256 cellar: :any,                 high_sierra:    "13856fba32b0dd67c81787b198d71ba02df7fa3a1e2b6e2d552b141c5f901855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64e68f6cc4a0a5cac29d81c8aa0dafb65ab5c635fb7971514e25923b84d1710e"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python@3.9"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  resource "homebrew-test-tetris.bin" do
    url "https://raw.githubusercontent.com/mgbellemare/Arcade-Learning-Environment/v0.7.0/tests/resources/tetris.bin"
    sha256 "36d5b5d3222f007ca8e3691cfc17f639801453b98438b1282dfd695ae44752f6"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/b5/d8/51ace1c1ea6609c01c7f46ca2978e11821aa0efaaa7516002ef6df000731/importlib_resources-5.4.0.tar.gz"
    sha256 "d756e2f85dd4de2ba89be0b21dba2a3bbec2e871a42a3a16719258a11f87506b"
  end

  # TODO: Check to see if `importlib-metadata` resource should be removed when switching to `python@3.10`
  # https://github.com/mgbellemare/Arcade-Learning-Environment/blob/v#{version}/setup.cfg
  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/82/10/600b88188a4e94562cfdf202ef1aca6fedda0723acae8a47376350ec0d5d/importlib_metadata-4.11.1.tar.gz"
    sha256 "175f4ee440a0317f6e8d81b7f8d4869f93316170a65ad2b007d2929186c8052c"
  end

  # TODO: Check to see if `zipp` resource should be removed when switching to `python@3.10`
  # https://github.com/python/importlib_resources/blob/#{importlib-resources.version}/setup.cfg
  resource "zipp" do
    url "https://files.pythonhosted.org/packages/94/64/3115548d41cb001378099cb4fc6a6889c64ef43ac1b0e68c9e80b55884fa/zipp-3.7.0.tar.gz"
    sha256 "9f50f446828eb9d45b267433fd3e9da8d801f614129124863f9c51ebceafb87d"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
      -DSDL_SUPPORT=ON
      -DSDL_DYNLOAD=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources.reject { |r| r.name == "homebrew-test-tetris.bin" }

    # error: no member named 'signbit' in the global namespace
    python_args = Language::Python.setup_install_args(libexec)
    python_cmake_options = "--cmake-options=-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}"
    python_args.insert((python_args.index "install"), python_cmake_options) if OS.mac?

    # `venv.pip_install_and_link buildpath` alternative to allow passing in arguments
    bin_before = Dir[libexec/"bin/*"].to_set
    system libexec/"bin/python3", *python_args
    bin.install_symlink (Dir[libexec/"bin/*"].to_set - bin_before).to_a

    site_packages = Language::Python.site_packages("python3")
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-ale-py.pth").write pth_contents
  end

  test do
    output = shell_output("#{bin}/ale-import-roms 2>&1", 2)
    assert_match "one of the arguments --import-from-pkg romdir is required", output
    output = shell_output("#{bin}/ale-import-roms .").lines.last.chomp
    assert_equal "Imported 0 / 0 ROMs", output

    testpath.install resource("homebrew-test-tetris.bin")
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

    output = shell_output("#{Formula["python@3.9"].opt_bin}/python3 test.py 2>&1")
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
