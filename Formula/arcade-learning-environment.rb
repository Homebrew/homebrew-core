class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment.git",
      tag:      "v0.7.4",
      revision: "069f8bd860b9da816cea58c5ade791025a51c105"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2af5cc5f2142ae169ee8f084ee0dee9737387fe4d29b000800f3e6e9d7d9f92"
    sha256 cellar: :any,                 arm64_big_sur:  "cb88b66ecaf3b0d5f4fa48d9e168c55085380f378e7084653312bb7efde3533d"
    sha256 cellar: :any,                 monterey:       "0d727d6a027d45b8f06d60c80af02b34c0702a3b9bdcb186b1d10a28be5a6535"
    sha256 cellar: :any,                 big_sur:        "29832ccb62b2e63e7a70067ae1a9c5766caab4f1a40e9a1041847b8269a42d96"
    sha256 cellar: :any,                 catalina:       "6f70478d210592616e3a11e881ada9681943b35937694c90639f278f1c3f200d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96879a347e05c3f50da2fd59d3995fad10895d6bc39f964af5a963332128b6d8"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python@3.10"
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

    output = shell_output("#{Formula["python@3.10"].opt_bin}/python3 test.py 2>&1")
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
